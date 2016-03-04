package controller;

import web.dbbean.RefListBean;
import web.dbbean.UserBean;
import web.dbbean.WorkLoadBean;
import web.dbbean.QCBundleBean;
import web.model.ReferenceList;
import web.model.UserManager;
import web.model.WorkLoadManager;

import java.io.IOException;

import java.io.InputStream;

import java.text.MessageFormat;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class WorkLoadServlet extends HttpServlet {
    @SuppressWarnings("compatibility:5820545057171486465")
    private static final long serialVersionUID = 6498321950259170196L;

    public WorkLoadServlet() {
        super();
    }
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
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
        
        WorkLoadBean wlBean = new WorkLoadBean();
        QCBundleBean wlQCBean = new QCBundleBean();
        WorkLoadManager wlm = new WorkLoadManager();
        ReferenceList RefList = new ReferenceList();
        UserBean userBean = new UserBean();
        UserManager userm = new UserManager();

        Properties errorProp = new Properties();
        InputStream inputStream =
            this.getClass().getClassLoader().getResourceAsStream("/properties/xyz_error.properties");
        errorProp.load(inputStream);
        
        
        getDataSource = sess.getAttribute("dataSource").toString();
        
        try {
            
            if (sess.getAttribute("wlBean") != null){
                 wlBean = (WorkLoadBean)sess.getAttribute("wlBean");             
            } 
            if (sess.getAttribute("userBean") != null) {
                 userBean = (UserBean)sess.getAttribute("userBean");
            }
            
            if(action.equals("viewWorkLoad")) {
                 String srchval = req.getParameter("srchVal");
                 String srchBy = req.getParameter("srchBy");
                 ArrayList<UserBean> userList = userm.getUserList(getDataSource,srchval, srchBy, userBean);
                 
                 if (userList.isEmpty()) {
                     errorMessage = (errorProp.getProperty("manage_users_nodata"));
                 }
                 else {
                    sess.removeAttribute("userList");
                    sess.setAttribute("userList", userList);
                 }
                 wlm.getCodes(getDataSource,wlBean);
                 
                ArrayList codesList = wlBean.getCodesList();
                sess.setAttribute("codeList", codesList);
                // sess.setAttribute("wlBean", wlBean);
                 ArrayList<RefListBean> codingUnits = RefList.getCodingUnits(getDataSource);
                 sess.setAttribute("codingUnits", codingUnits);
                 req.setAttribute("errorMessage", errorMessage);
                 redirect = "/jsp/xyz_WorkAssign.jsp";           
            }
            else if(action.equals("Reset")) {
                sess.removeAttribute("wlBean");
                StringBuffer results = new StringBuffer();
                results.setLength(0);
                res.getWriter().write(results.toString());
                return;
            }
            else if(action.equals("filterUserList")) {
                 String srchval = req.getParameter("srchVal");
                 String srchBy = req.getParameter("srchBy");
                 userBean = (UserBean)sess.getAttribute("userBean");
                 String username;
                 username = userBean.getUsername();
                 String usertype;
                 usertype = userBean.getUserType();
                 ArrayList<UserBean> userList = userm.getUserList(getDataSource,srchval, srchBy, userBean);
                 
                 if (userList.isEmpty()) {
                     errorMessage = (errorProp.getProperty("manage_users_nodata"));
                 }
                 else {
                    sess.removeAttribute("userList");
                    sess.setAttribute("userList", userList);
                 }
                 req.setAttribute("errorMessage", errorMessage);
                 redirect = "/jsp/xyz_WorkUserList.jsp";            
            }
            else if (action.equals("MoreWorkListResults")){
                System.out.println("Getting more work list results");
                System.out.println("Work list size: " + wlBean.getWlList().size());
                
                //grab the parameters passed in which represent the current poistion in the list
                //and the number of records the caller would like returned
                int currentPosition = Integer.parseInt(req.getParameter("currentPosition"));
                int actualToRequest = Integer.parseInt(req.getParameter("actualToRequest"));
                
                System.out.println("Current position is : " + currentPosition);
                System.out.println("Number requested is: " + actualToRequest);
                
                //get the record list
                ArrayList wlList = wlBean.getWlList();
                WorkLoadBean currWlBean = new WorkLoadBean();
                
                StringBuffer results = new StringBuffer();
                results.setLength(0);
                
                //build a json object from the record list using containing the requested
                //number of records and beginning at the requested position in the array
                for (int i=0; i<actualToRequest; i++){
                    currWlBean = (WorkLoadBean)wlList.get(currentPosition);
                    results.append("<tr class=\"RecordRow\" id=\"RecordRow\">" +
                                "<td style=\"min-width: 120px; max-width: 120px;\">" + currWlBean.getCustid() + 
                                "</td><td style=\"min-width: 40px; max-width: 40px;\">" +currWlBean.getState() + 
                                "</td><td style=\"min-width: 50px; max-width: 50px;\">" + currWlBean.getTimeZone() +
                                "</td><td style=\"min-width: 60px; max-width: 60px;\">" + currWlBean.getUsername() +
                                "</td><td style=\"min-width: 45px; max-width: 45px;\">" + currWlBean.getCUnit() +
                                "</td><td style=\"min-width: 75px; max-width: 75px;\">" + currWlBean.getStatusName() +
                                "</td><td style=\"min-width: 75px; max-width: 75px;\">" + currWlBean.getQaCycleName() +
                                "</td><td style=\"min-width: 75px; max-width: 75px;\">" + currWlBean.getDateCreated() +
                                "</td><td style=\"min-width: 75px; max-width: 75px;\">" + currWlBean.getDateAssigned() +
                                "</td><td style=\"min-width: 75px; max-width: 75px;\">" + currWlBean.getDateStarted() + 
                                "</td><td style=\"min-width: 75px; max-width: 75px;\">" + currWlBean.getDateCompleted() +
                                "</td><td style=\"min-width: 40px; max-width: 40px;\">" + currWlBean.getProdTime() +                                   
                                "</td><td style=\"display:none\">" + currWlBean.getStatus() +
                                "</td><td style=\"display:none\">" + currWlBean.getQaCycle()+ "</td></tr>\n");
                    currentPosition++;
                }
                
                //System.out.println(results.toString());

                res.getWriter().write(results.toString());
                return;
            }
            else if (action.equals("ExitWorkAssign")) {
                sess.removeAttribute("userList");
                sess.removeAttribute("wlBean");
                sess.removeAttribute("wlQCBean");
                redirect = "/loginProcess?action=verifyLogin";
            }
            else if (action.equals("getWorkAssignList")) {
                wlBean.getWlList().clear();
                String usrCUnit = "";

                wlBean.setSelState(wlm.emptyIfNull(req.getParameter("selState")));
                wlBean.setSelUserName(wlm.emptyIfNull(req.getParameter("selUserName")));
                wlBean.setSelCUnit(wlm.emptyIfNull(req.getParameter("selCUnit")));
                wlBean.setSelQaCycle(wlm.emptyIfNull(req.getParameter("selQaCycle")));
                wlBean.setSelStatus(wlm.emptyIfNull(req.getParameter("selStatus")));
                wlBean.setSelTimeZone(wlm.emptyIfNull(req.getParameter("selTimeZone")));
                wlBean.setSelCustID(wlm.emptyIfNull(req.getParameter("selCustID")));
                wlBean.setSelDateType(wlm.emptyIfNull(req.getParameter("selDateType")));
                wlBean.setSelDateVal(wlm.emptyIfNull(req.getParameter("selDateVal")));
                
                if (userBean.getUserType().equalsIgnoreCase("3"))  {
                    usrCUnit = userBean.getCodingUnit();
                }
                
                wlm.getWorkRecords(getDataSource,wlBean, usrCUnit);
                sess.setAttribute("wlBean", wlBean);
                redirect = "/jsp/xyz_WorkList.jsp";                
            }
            else if (action.equals("WorkAssign")) {
                String selUserName = req.getParameter("selUserName");
                String selUserType = req.getParameter("selUserType");
                String selRecCustid = req.getParameter("selRecCustid");
                String selRecStatus = req.getParameter("selRecStatus");
                int selRecQaCycle = Integer.valueOf(req.getParameter("selRecQaCycle"));
                String retStatus ="";
                String returnval = "";
                String retMessage="";
                String errmesg = "";
                    
                StringBuffer results = new StringBuffer();
                results.setLength(0);
                
                returnval = wlm.WorkAssign(getDataSource,selUserName, selRecCustid, selRecQaCycle);
                String[] split = returnval.split(":");
                retStatus = split[0];
                errmesg = split[1];
             
                retMessage = MessageFormat.format(errorProp.getProperty("WorkAssign_Status_"+retStatus), errmesg);

                results.append(retStatus+":"+retMessage);
                res.getWriter().write(results.toString());
                return;
            }
            else if (action.equals("WorkAssignQC")) {
                String selUser = req.getParameter("selUser");
                String selBundleId = req.getParameter("selBundleId");
                String qcLevel = req.getParameter("qcLevel");
                int selQaCycle = 2;
                int retStatus =0;
                String retMessage="";
                    
                StringBuffer results = new StringBuffer();
                results.setLength(0);
                
                retStatus = wlm.WorkAssignQC(getDataSource, selUser,selBundleId, qcLevel,selQaCycle);

                retMessage = errorProp.getProperty("WorkAssign_Status_"+retStatus);
                results.append(retStatus+":"+retMessage);
                res.getWriter().write(results.toString());
                return;
            }
            else if (action.equals("getWorkAssignQCList")) {
                System.out.println("inside getWorkAssignQCList");
                String usrCUnit = "";

                if (userBean.getUserType().equalsIgnoreCase("3"))  {
                    usrCUnit = userBean.getCodingUnit();
                }
                if (wlBean != null){
                    sess.removeAttribute("wlBean");
                }
                
                wlQCBean = wlm.getWorkQCList(getDataSource, usrCUnit);
                System.out.println("getWorkQCList DONE! "+ wlQCBean.getErrorMessage()+" "+ wlQCBean.getWlQCList().get(0).toString());
                sess.setAttribute("wlQCBean", wlQCBean);
                redirect = "/jsp/xyz_WorkQCList.jsp";                
            }
                        
            req.setAttribute("errorMessage", errorMessage);
            RequestDispatcher rd = sc.getRequestDispatcher(redirect);
            rd.forward(req, res);
            

        } catch (Exception ee) {
            ee.printStackTrace();
            String str = ee.getMessage();
            errorMessage = "WorkLoadServlet Exception : " + str;
            req.setAttribute("errorMessage", errorMessage);
            redirect = "/jsp/xyz_ErrorPage.jsp";
            RequestDispatcher rd = req.getRequestDispatcher(redirect);
            rd.forward(req, res);
        }
        
    }

}
