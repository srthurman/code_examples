//Sara

package controller;

import geo.j2ee.util.weblogic.OIDAccessor;

import web.dbbean.RefListBean;
import web.dbbean.UserBean;
import web.model.ReferenceList;
import web.model.UserManager;

import java.io.IOException;
import java.io.InputStream;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class LoginServlet extends HttpServlet {

    UserManager userM = new UserManager();
    UserBean userBean = new UserBean();
    String groupName = "xyz";
    

    public LoginServlet() {
        super();
    }

    /**
     * All init pertinent functionality handled in the super class.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        //      System.out.println("Login Servlet is Initialized. ");
    }

    /**
     * Handles every action to the doPost, to make it simple.
     */
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String userExists;
        String redirect = null;
        String errorMessage;
        HttpSession sess = req.getSession(true);
        String action = req.getParameter("action");
        ServletContext sc = getServletContext();
        String path = "xyz_ds";
        String getDataSource = "";
        StringBuffer results = new StringBuffer();
        boolean userInGroup;
        boolean userHasDBAccount;
        ReferenceList RefList = new ReferenceList();
        Properties errorProp = new Properties();
        getDataSource = setSessionDatasource(sess, path);

        try {
////set session variables
            if (sess.getAttribute("codingUnits") == null) {           
                ArrayList<RefListBean> codingUnits = RefList.getCodingUnits(getDataSource);
                sess.setAttribute("codingUnits", codingUnits);
            }
            
            if (sess.getAttribute("userTypes") == null) {           
                ArrayList<RefListBean> userTypes = RefList.getUserTypes(getDataSource);
                sess.setAttribute("userTypes", userTypes);
            }
            
            
////handle requests
            if (action.equals("verifyLogin")) {
                String ssoUsername = OIDAccessor.getAuthUser(req);
                userExists = verifyLogin(ssoUsername, getDataSource);
                redirect = redirectLogin(userExists, req);
            } else if (action.equals("verifyUserOID")) {
                String username = req.getParameter("username");
                String retStatus;
                String userInfo;
                String retMessage;
                
//                System.out.println("Check if user in OID");
//                System.out.println(OIDAccessor.getUsers(username).size());
                
                if (OIDAccessor.getUsers(username).size() == 1) {
                    userInfo = getUserInfoOID(username);
                    retStatus = "true";
                    retMessage = retStatus + ":" + userInfo;
//                    System.out.println(retMessage);
                } else {
                    //errorMessage = errorProp.getProperty("user_username_notfound");
                    errorMessage = "User Information is not found in OID Server. Contact xyz Admin list with any issues.";
                    System.out.println(errorMessage);
                    retStatus = "false";
                    retMessage = retStatus + ":" + errorMessage;
                    System.out.println(retMessage);
                }
                
                results.append(retMessage);
                res.getWriter().write(results.toString());
                return;
            } else if (action.equals("logout")) {
                if(invalidateSession(req)){                
                    results.append("Success");
                }else{
                    results.append("Fail");
                }
                res.getWriter().write(results.toString());
                return;
            }
        } catch (Exception ee) {
            ee.printStackTrace();
            String str = ee.getMessage();
            errorMessage = "LoginServlet Exception : " + str;
            req.setAttribute("errorMessage", errorMessage);
            redirect = "/jsp/xyz_ErrorPage.jsp";
            RequestDispatcher rd = sc.getRequestDispatcher(redirect);
            rd.forward(req, res);
        }

        RequestDispatcher rd = sc.getRequestDispatcher(redirect);
        rd.forward(req, res);

    }
    public String setSessionDatasource (HttpSession session, String path) throws IOException {
        String getDataSource = "";
        if (session.getAttribute("dataSource") != null) {
            getDataSource = session.getAttribute("dataSource").toString();
        } else {
            Properties configProp = new Properties();
            InputStream inputStream =
                this.getClass().getClassLoader().getResourceAsStream("/properties/configDs.properties");
            configProp.load(inputStream);
            getDataSource = configProp.getProperty(path);
            session.setAttribute("dataSource", getDataSource);
        }  
        
        return getDataSource;
    }
    
    public String verifyLogin(String username, String dataSource) throws Exception {
//        System.out.println("verifyLogin method");
        boolean userInGroup;
        boolean userHasDBAccount;
        String retStatus = "None";

        userInGroup = OIDAccessor.isUserInGroup(username, groupName);
        userHasDBAccount = userM.userInDB(dataSource, username);
        
//        System.out.print("userInGroup: ");System.out.println(userInGroup);
//        System.out.print("userHasDBAccount: ");System.out.println(userHasDBAccount);

        if (userInGroup && userHasDBAccount) {
            userBean = userM.getUserByName(dataSource, username);
            retStatus = "Both";
        } else if (userHasDBAccount) {
            retStatus = "DBAccount";
        //} else if (userInGroup) {      
        } else {      
            userBean.setUsername(username);
            userBean.setFirstName(OIDAccessor.getUserAttrStringVal(username, OIDAccessor.OID_GIVEN_NAME));
            userBean.setLastName(OIDAccessor.getUserAttrStringVal(username, OIDAccessor.OID_SN));
            userBean.setEmail(OIDAccessor.getUserAttrStringVal(username, OIDAccessor.OID_EMAIL_ATTR));
            if (userInGroup) {
                retStatus = "OIDGroup";
            };
        };
        
//        System.out.print("retStatus: ");System.out.println(retStatus);
        return retStatus;
    }

    public String redirectLogin(String validUser, HttpServletRequest req) {
//        System.out.print("redirectLogin method"); System.out.println(validUser);
        HttpSession session = req.getSession(true);
        String redirect = "";
        String errorMessage = "";
        
        if (validUser.equals("Both")) {
//            System.out.println("Both DBAccount and OID Group exists.");
            if ((userBean.getUserStatus().equalsIgnoreCase("Inactive")) ||
                (userBean.getUserStatus().equalsIgnoreCase("Pending"))) {
                redirect = "/jsp/xyz_userInactive.jsp";

            } else if (userBean.getUserStatus().equalsIgnoreCase("Active")) {
                session.setAttribute("userBean", userBean);
                redirect = "/jsp/xyz_menu.jsp";
            }
        } else if (validUser.equals("OIDGroup") || validUser.equals("None")) {
//            System.out.println("DBAccount does not exist");
            session.setAttribute("newUserBean", userBean);
            redirect = "/jsp/xyz_accountRequest.jsp";
        } else if (validUser.equals("DBAccount")) {
//            System.out.println("DBAccount exists, OID Group does not.");
            errorMessage = "Your user account has not been added to the OID group. Contact xyz Admin list.";
            req.setAttribute("errorMessage", errorMessage);
            redirect = "/jsp/xyz_ErrorPage.jsp";
        }
        return redirect;
    }
    
    public String getUserInfoOID(String username) throws Exception {
        String fName = OIDAccessor.getUserAttrStringVal(username, OIDAccessor.OID_GIVEN_NAME);
        String lName = OIDAccessor.getUserAttrStringVal(username, OIDAccessor.OID_SN);
        String email = OIDAccessor.getUserAttrStringVal(username, OIDAccessor.OID_EMAIL_ATTR);
        
        return fName + ":" + lName + ":" + email;
    }
    
    /**
     * This method is used to invalidate the session and clearing all Attributes
     * @param req
     * @return
     */
    public boolean invalidateSession (HttpServletRequest req) {
        HttpSession session = req.getSession(false); //grab the session, if there is no session then do not create new one
        String sessAttr = "";
        
        if (session != null){
            Enumeration attrs =  session.getAttributeNames();
            while(attrs.hasMoreElements()) {
                sessAttr = (String)attrs.nextElement();
                System.out.println("Removing session attribute: " + sessAttr);
                session.removeAttribute(sessAttr);
            }
            session.invalidate();
            return true;
        }else{        
            return false;
        }
    }
}
