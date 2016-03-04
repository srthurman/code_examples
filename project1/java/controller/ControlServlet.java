//Sara

package controller;

import web.dbbean.RecordBean;
import web.dbbean.UserBean;
import web.dbbean.WorkLoadBean;
import web.model.RecordManager;
import web.model.ReferenceList;
import web.model.UserManager;
import web.model.WorkLoadManager;

import java.io.IOException;
import java.io.InputStream;

import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class ControlServlet extends HttpServlet {
    public ControlServlet() {
        super();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        this.doPost(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession sess = req.getSession(true);
        ServletContext sc = getServletContext();
        String redirect = null;
        String errorMessage = null;
        String getDataSource = null;
        String action = null;
        action = req.getParameter("action");
        UserBean userBean = new UserBean();
        UserManager userm = new UserManager();
        WorkLoadManager wlm = new WorkLoadManager();
        WorkLoadBean wlBean = new WorkLoadBean();
        boolean supOrAdmin = false;

        Properties errorProp = new Properties();
        InputStream inputStream =
            this.getClass().getClassLoader().getResourceAsStream("/properties/xyz_error.properties");
        errorProp.load(inputStream);

        sess.removeAttribute("refBean");
        //        sess.removeAttribute("blockID");
        sess.removeAttribute("queBean");
        sess.removeAttribute("RecBean");

        try {

            if (sess.getAttribute("userBean") != null) {
                userBean = (UserBean)sess.getAttribute("userBean");
            }
            
            //flag if user is supervisor or admin
            if ((userBean.getUserType().equalsIgnoreCase("1")) || (userBean.getUserType().equalsIgnoreCase("2")) || (userBean.getUserType().equalsIgnoreCase("5"))) {
                supOrAdmin = false;
            } else {
                supOrAdmin = true;
            }

            if (action.equals("getNewRecord")) {
                RecordBean queBean = new RecordBean();
                RecordManager rm = new RecordManager();

                String[] newRecordArray = new String[4];
                String custID = "";
                int ret_status = 99;
                String qaCycle = req.getParameter("qaCycle");
                String bundleId = "";

                getDataSource = sess.getAttribute("dataSource").toString();

                 //block verfication from manual
                if ( qaCycle.equals("0") && (userBean.getUserType().equals("5"))){
                    errorMessage = errorProp.getProperty("Manual_NoQual");
                    redirect = "/jsp/xyz_menu.jsp";
                }
                 //block manual and verfication from QC
                 else if ( (qaCycle.equals("1") || qaCycle.equals("2")) && (userBean.getUserType().equals("1") || userBean.getUserType().equals("5")))  {
                     errorMessage = errorProp.getProperty("Referral_Qc");
                     redirect = "/jsp/xyz_menu.jsp";
                 }
                 else {
                //get CustID, qaCycle and returnStatus from xyz_get_record.get_custid procedure
                    if (qaCycle.equals("2")) {
                        newRecordArray = rm.checkForNewQcBundle(getDataSource, userBean, qaCycle);
                        bundleId = newRecordArray[3];
                    } else {
                        newRecordArray = rm.checkForNewRecords(userBean, getDataSource, qaCycle);
                    }
    
                    custID = newRecordArray[0];
                    ret_status = Integer.parseInt(newRecordArray[1]);
                    qaCycle = newRecordArray[2];
    
                    if (ret_status == 0) {
                        // If QueueBean is not null/return status = 0 then getRecord from Address table;
                        queBean.setCustid(custID);
                        queBean.setQaCycle(qaCycle);
                        queBean.setUsername(userBean.getUsername());
                        if (qaCycle.equals("2")) {
                            queBean.setBundleId(bundleId);
                        }
    
                        sess.setAttribute("queBean", queBean);
                        redirect = "/CS?action=getAddrRecord";
                        
    
                    } else if (ret_status == 1) {
                        // If QueueBean is null/return status = 1 then return an error message
                        errorMessage = errorProp.getProperty("Queue_nodata");
                        redirect = "/jsp/xyz_menu.jsp";
                    } else if ((ret_status == 2)|| (ret_status == 3)) {
                        // If return status = 3 then return an error message
                        errorMessage = errorProp.getProperty("Queue_error");
                        redirect = "/jsp/xyz_menu.jsp";
                    }
                
             }

            } else if (action.equals("getQCRecords")) {
                RecordBean RecBean = new RecordBean();
                RecordBean queBean = new RecordBean();
                RecordBean qcBean = new RecordBean();
                RecordManager rm = new RecordManager();
                ReferenceList RefList = new ReferenceList();

                    if ((userBean.getUserType().equalsIgnoreCase("1")) || (userBean.getUserType().equalsIgnoreCase("5"))) {
                    errorMessage = errorProp.getProperty("Referral_Qc");
                    redirect = "/jsp/xyz_menu.jsp";
                }
                else {
                
                    String[] newRecordArray = new String[4];
                    String custID = "";
                    int ret_status = 99;
                    String qaCycle = req.getParameter("qaCycle");
                    String bundleId = "";
    
                    getDataSource = sess.getAttribute("dataSource").toString();
    
                    //get CustID, qaCycle and returnStatus from xyz_get_record.get_custid procedure
                    System.out.print("userBean.getUserName: ");
                    System.out.println(userBean.getUsername());
                    newRecordArray = rm.checkForNewQcBundle(getDataSource, userBean, qaCycle);
                    custID = newRecordArray[0];
                    qaCycle = newRecordArray[1];
                    bundleId = newRecordArray[2];
                    ret_status = Integer.parseInt(newRecordArray[3]);
    
                    if (ret_status == 0) {
                        // If QueueBean is not null/return status = 0 then getRecord from Address table;
                        queBean.setCustid(custID);
                        queBean.setQaCycle(qaCycle);
                        queBean.setBundleId(bundleId);
    
                        // Added by Shashi to get Address record including the corrected data from db.
                        sess.setAttribute("queBean", queBean);
                        redirect = "/CS?action=getAddrRecord";
    
                    } else if (ret_status == 1) {
                        // If QueueBean is null/return status = 1 then return an error message
                        errorMessage = errorProp.getProperty("Queue_nodata");
                        redirect = "/jsp/xyz_menu.jsp";
                    } else if (ret_status == 2) {
                        // If return status = 2 then return an error message
                        errorMessage = errorProp.getProperty("Queue_error");
                        redirect = "/jsp/xyz_menu.jsp";
                    }
                }
            } else if (action.equals("getOnHoldRecords")) {
                errorMessage = errorProp.getProperty("PageConstr");
                redirect = "/jsp/xyz_menu.jsp";
            } else if (action.equals("getRefRecords")) {
                errorMessage = errorProp.getProperty("PageConstr");
                redirect = "/jsp/xyz_menu.jsp";
            } else if (action.equals("getOid")) {
                errorMessage = errorProp.getProperty("AdminOid_NoQaul");
                redirect = "/jsp/xyz_menu.jsp";
            } else if (action.equals("getMAF")){
                errorMessage = errorProp.getProperty("Verification_NoMaf");
                redirect = "/jsp/xyz_menu.jsp";
            } else if (action.equals("getWorkAssign")) {

                if (!(supOrAdmin)) {
                    errorMessage = errorProp.getProperty("WUAssign_NoQaul");
                    redirect = "/jsp/xyz_menu.jsp";
                } else {
                    if (sess.getAttribute("wlBean") != null) {
                        sess.removeAttribute("wlBean");
                    }
                    redirect = "/WorkLoadServlet?action=viewWorkLoad";
                }

            } else if (action.equals("getReports")) {
                if (!(supOrAdmin)) {
                    errorMessage = errorProp.getProperty("Reports_NoQaul");
                    redirect = "/jsp/xyz_menu.jsp";
                } else {
                    //TODO: put reports code here
                    redirect = "/jsp/xyz_menu.jsp";
                }
            } else if (action.equals("getUserAccounts")) {
                    if (!(userBean.getUserType().equalsIgnoreCase("4"))) {
                    errorMessage = errorProp.getProperty("AdminUser_NoQaul");
                    redirect = "/jsp/xyz_menu.jsp";
                } else {
                    String srchval = "ALL";
                    String srchBy = "USERLIST";
                    userBean = (UserBean)sess.getAttribute("userBean");
                    String username;
                    username = userBean.getUsername();
                    String usertype;
                    usertype = userBean.getUserType();
                    getDataSource = sess.getAttribute("dataSource").toString();
                    ArrayList<UserBean> userList = userm.getUserList(getDataSource, srchval, srchBy, userBean);


                    if (sess.getAttribute("wlBean") != null) {
                        sess.removeAttribute("wlBean");
                    }

                    wlm.getCodes(getDataSource, wlBean);
                    sess.setAttribute("wlBean", wlBean);

                    if (userList.isEmpty()) {
                        errorMessage = (errorProp.getProperty("manage_users_nodata"));
                    } else {
                        sess.removeAttribute("userList");
                        sess.setAttribute("userList", userList);
                    }
                    req.setAttribute("errorMessage", errorMessage);
                    redirect = "/jsp/xyz_UserAccounts.jsp";
                }

            } else if (action.equals("ExitWorkUserAccount")) {
                sess.removeAttribute("userList");
                sess.removeAttribute("wlBean");
                redirect = "/loginProcess?action=verifyLogin";
            } else if (action.equals("getRequestAccess")) {
                if (!(userBean.getUserType().equalsIgnoreCase("4"))) {
                    errorMessage = errorProp.getProperty("AdminRequest_NoQaul");
                    redirect = "/jsp/xyz_menu.jsp";
                } else {
                    UserBean newUserBean = new UserBean();
                    sess.setAttribute("newUserBean", newUserBean);
                    redirect = "/jsp/xyz_accountRequest.jsp";
                }

            } else if (action.equals("viewTests")) {
                redirect = "/jsp/xyz_TestingPage.jsp";
            }

            req.setAttribute("errorMessage", errorMessage);

        } catch (Exception ee) {
            ee.printStackTrace();
            String str = ee.getMessage();
            errorMessage = "ControlServlet Exception : " + str;
            req.setAttribute("errorMessage", errorMessage);
            redirect = "/jsp/xyz_ErrorPage.jsp";
            RequestDispatcher rd = req.getRequestDispatcher(redirect);
            rd.forward(req, res);
        }

        RequestDispatcher rd = sc.getRequestDispatcher(redirect);
        rd.forward(req, res);
    }
}
