//Sara
package controller;

import web.dbbean.RefListBean;
import web.dbbean.UserBean;
import web.dbbean.VerificationBean;
import web.model.ReferenceList;
import web.model.VerificationManager;

import java.io.IOException;
import java.io.InputStream;

import java.text.SimpleDateFormat;

import java.util.Date;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class VerificationServlet extends HttpServlet {
    public VerificationServlet() {
        super();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        this.doPost(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession sess = req.getSession(true);
        ServletContext sc = getServletContext();
        String action = null;
        String redirect = null;
        action = req.getParameter("action");
        String errorMessage = "";
        UserBean userBean = new UserBean();
        

        RefListBean refBean = new RefListBean();
        ReferenceList refList = new ReferenceList();
        LoginServlet loginServlet = new LoginServlet();
        String getDataSource = null;
        Integer retStatus = 0;
        String manualStatus = "";

        StringBuffer results = new StringBuffer();
        results.setLength(0);
        StringBuffer resultsBlk = new StringBuffer();
        resultsBlk.setLength(0);

        Properties errorProp = new Properties();
        InputStream inputStream =
            this.getClass().getClassLoader().getResourceAsStream("/properties/xyz_error.properties");
        errorProp.load(inputStream);

        getDataSource = sess.getAttribute("dataSource").toString();

        try {

            VerificationBean verAddrBean = new VerificationBean();
            VerificationBean verQueBean = new VerificationBean();
            VerificationManager vm = new VerificationManager();
            
            if (sess.getAttribute("userBean") != null) {
                userBean = (UserBean)sess.getAttribute("userBean");
            }
            if (sess.getAttribute("verQueBean") != null) {
                verQueBean = (VerificationBean)sess.getAttribute("verQueBean");
            }
            if (sess.getAttribute("verAddrBean") != null) {
                verAddrBean = (VerificationBean)sess.getAttribute("verAddrBean");
            }
            if (sess.getAttribute("refBean") != null) {
                refBean = (RefListBean)sess.getAttribute("refBean");
            }

            if (action.equals("getNewRecord")) {
                String userType = userBean.getUserType();
                String[] newRecordArray = new String[3];
        
                String custID = "";
                int ret_status = 99;
                String qaCycle = req.getParameter("qaCycle");
                
                //block manual, qc, and supervisors from verfication
                if (qaCycle.equals("0") &&
                    (userType.equalsIgnoreCase("1") ||
                     userType.equalsIgnoreCase("2") ||
                     userType.equalsIgnoreCase("3")))
                {
                    errorMessage = errorProp.getProperty("Verification_NoQual");
                    redirect = "/jsp/xyz_menu.jsp";
                }
                
                newRecordArray = vm.checkForNewRecords(userBean, getDataSource, qaCycle);
                
                custID = newRecordArray[0];
                ret_status = Integer.parseInt(newRecordArray[1]);
                qaCycle = newRecordArray[2];
                
                if (ret_status == 0) {
                    // If QueueBean is not null/return status = 0 then getRecord from Address table;
                    verQueBean.setCustid(custID);
                    verQueBean.setQaCycle(qaCycle);
                    verQueBean.setUsername(userBean.getUsername());                
                    
                    sess.setAttribute("verQueBean", verQueBean);
                    redirect = "/VerificationServlet?action=getAddrRecord";
                    
                
                } else if (ret_status == 1) {
                    // If QueueBean is null/return status = 1 then return an error message
                    errorMessage = errorProp.getProperty("Queue_nodata");
                    redirect = "/jsp/xyz_menu.jsp";
                } else if ((ret_status == 2)|| (ret_status == 3)) {
                    // If return status = 3 then return an error message
                    errorMessage = errorProp.getProperty("Queue_error");
                    redirect = "/jsp/xyz_menu.jsp";
                }
            } else if
            (action.equals("getAddrRecord")) {
                System.out.println("getAddrRecord: " + verQueBean.getCustid());
                System.out.println("getAddrRecord qaCycle: " + verQueBean.getQaCycle());
                // Added by Shashi to get Address record including the corrected data from db.
                verAddrBean = vm.getAddressRecord(getDataSource, verQueBean, verAddrBean);
                
                System.out.println("VerificationServlet: getAddressRecord : " + verAddrBean.getCustid());
                if (verAddrBean.getRetStatus() == 0) {
                
                    sess.setAttribute("verAddrBean", verAddrBean);
                    sess.setAttribute("recType", "verifier");
                    redirect = "/jsp/xyz_record.jsp";
                    verQueBean.setProdTimeType("O");
                    vm.UpdateProdTime(getDataSource, verQueBean);
                
                } else {
                    
                    errorMessage = errorProp.getProperty("AddrRec_error", verQueBean.getCustid());
                    redirect = "/jsp/xyz_menu.jsp";
                    
                }

            }
            else if
            (action.equals("ExitRecord")) {
                verQueBean.setProdTimeType("C");
                vm.UpdateProdTime(getDataSource, verQueBean);
                sess.removeAttribute("refBean");
                sess.removeAttribute("blockID");
                sess.removeAttribute("verQueBean");
                sess.removeAttribute("verAddrBean");
                sess.removeAttribute("recType");
                sess.removeAttribute("qaCycle");
                redirect = "/loginProcess?action=verifyLogin";
            } else if
            (action.equals("logout")) {
                //update the Prod time before invalidate the Session
                verQueBean.setProdTimeType("C");
                vm.UpdateProdTime(getDataSource, verQueBean);

                if (loginServlet.invalidateSession(req)) {
                    results.append("Success");
                } else {
                    results.append("Fail");
                }
                res.getWriter().write(results.toString());
                return;
            } else if (action.equals("sessionCheck")) {
                String retMessage = "";

                SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
                Date date = new Date();
                System.out.println("Session Check: " + userBean.getUsername() + ", Date: " + date);

                if (userBean.getUsername().equals("") || userBean.getUsername() == null) {
                    retMessage = "Failure";
                } else {
                    retMessage = "Success";
                }
                res.setContentType("text/text;charset=UTF-8");
                results.append(retMessage);
                res.getWriter().write(results.toString());
                return;
            }
            //action logoutCheck for testing only, not needed in real application
            else if (action.equals("logoutCheck")) {
                Date date = new Date();
                String retMessage = "testing the logout";
                System.out.println("Logout Check: " + retMessage + ", Date: " + date);

                res.setContentType("text/text;charset=UTF-8");
                results.append(retMessage);
                res.getWriter().write(results.toString());
                return;
            }
        } catch (Exception ee) {
            System.out.println("Error in VerificationServlet: action -" + action);
            ee.printStackTrace();
            String str = ee.getMessage();
            errorMessage = "VerificationServlet Exception : " + str;
            req.setAttribute("errorMessage", errorMessage);
            redirect = "/jsp/xyz_ErrorPage.jsp";
            RequestDispatcher rd = req.getRequestDispatcher(redirect);
            rd.forward(req, res);
        }
        if (!(redirect == null || redirect.equals(""))) {
            RequestDispatcher rd = sc.getRequestDispatcher(redirect);
            rd.forward(req, res);
        }
    }
}
