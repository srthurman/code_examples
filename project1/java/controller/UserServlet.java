//Sara
package controller;

import web.dbbean.UserBean;
import web.model.UserManager;

import java.io.IOException;
import java.io.InputStream;

import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Properties;

import javax.naming.NamingException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class UserServlet extends HttpServlet {
    public UserServlet() {
        super();
    }
    
    Integer retStatus = 0;
    String action = null;
    String redirect = null;
    String errorMessage = "";
    String retMessage = "";
    String getDataSource = null;
    StringBuffer results = new StringBuffer();
    Properties errorProp = new Properties();
    UserManager um = new UserManager();
    UserBean userBean = new UserBean();
    
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        this.doPost(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession sess = req.getSession(true);
        ServletContext sc = getServletContext();
        
        action = req.getParameter("action");
        results.setLength(0);
        InputStream inputStream =
            this.getClass().getClassLoader().getResourceAsStream("/properties/xyz_error.properties");
        errorProp.load(inputStream);
        
        
        try {
////set session variables
            if (sess.getAttribute("userBean") != null) {
                userBean = (UserBean)sess.getAttribute("userBean");
            }  
            
            getDataSource = sess.getAttribute("dataSource").toString();
            
////handle requests
            if (action.equals("requestAccount")) {                
                System.out.println("requestAccount - user servlet");
                if (sess.getAttribute("newUserBean") != null){
                    UserBean newUserBean = createNewUserBean(req);
                    retMessage = requestAccount(getDataSource, newUserBean);
                } else {
                    retMessage = requestAccount(getDataSource, userBean);
                }

                results.append(retMessage);
                res.getWriter().write(results.toString());
                return;
            }else if (action.equals("updateUserAccount")){
//                userList : userList, selCodingUnit : selCodingUnit, selUserType: selUserType, selUserStatus : selUserStatus
                ArrayList userListArray = new ArrayList();
                
                String[] selUserArray = req.getParameterValues("selUserArray[]");
                String selCodingUnit = req.getParameter("selCodingUnit");
                String selUserType = req.getParameter("selUserType");
                String selUserStatus = req.getParameter("selUserStatus");
                int retMessage=1;
                for (int i = 0; i < selUserArray.length; i++) {        
                //    System.out.println("Updating User: " +selUserArray[i] +" with "+selCodingUnit+", "+selUserType+", "+selUserStatus);
                    //Make a UserBean from the Ajax parameters
                    UserBean updateUserBean = new UserBean();
                    
                    updateUserBean.setUsername(selUserArray[i]);
                    updateUserBean.setUserStatus(selUserStatus);
                    updateUserBean.setUserType(selUserType);
                    updateUserBean.setCodingUnit(selCodingUnit);
                    //call UserManager.java to pass in the userBean
                    
                    retMessage = um.updateUserAccount(getDataSource, updateUserBean);
                    System.out.println("retMessage: "+retMessage);
                }
                if(retMessage == 0){
                ArrayList<UserBean> userList = um.getUserList(getDataSource,"USERLIST", "ALL", userBean);
                //Refresh the UserList bean
                    if (userList.isEmpty()) {
                         errorMessage = (errorProp.getProperty("manage_users_nodata"));
                    }
                    else {
                        sess.removeAttribute("userList");
                        sess.setAttribute("userList", userList);  
                    }
                }
                redirect = "/jsp/xyz_UserList.jsp";      
            }
            
        } catch (Exception ee) {
            System.out.println("Error in UserServlet: action -" + action);
            ee.printStackTrace();
            String str = ee.getMessage();
            errorMessage = "UserServlet Exception : " + str;
            req.setAttribute("errorMessage", errorMessage);
            redirect = "/jsp/xyz_ErrorPage.jsp";
            RequestDispatcher rd = req.getRequestDispatcher(redirect);
            rd.forward(req, res);
        }
        if (!(redirect==null || redirect.equals(""))) {        
            RequestDispatcher rd = sc.getRequestDispatcher(redirect);
            rd.forward(req, res);
        }
    }
    
    public String requestAccount (String getDataSource, UserBean userBean) throws SQLException, NamingException {
        boolean userHasDBAccount;
        String username = userBean.getUsername();
        System.out.println(username);
        
        userHasDBAccount = um.userInDB(getDataSource, username);
        
        if (userHasDBAccount) {
            retStatus = 404;
            errorMessage = errorProp.getProperty("user_username_dup", username);
        } else {
            retStatus = um.requestUserAccount(getDataSource, userBean);
            
            if (retStatus==0) {
                errorMessage = errorProp.getProperty("user_add_success");
            } else {
                errorMessage = errorProp.getProperty("user_add_error", username);
            }
        }
        
        return retStatus + ":" + errorMessage;
    }
    
    public UserBean createNewUserBean (HttpServletRequest req) {
        UserBean newUserBean = new UserBean();
        
        newUserBean.setUsername(req.getParameter("username"));
        newUserBean.setFirstName(req.getParameter("firstName"));
        newUserBean.setLastName(req.getParameter("lastName"));
        newUserBean.setEmail(req.getParameter("email"));
        newUserBean.setCcemail(req.getParameter("ccemail"));
        newUserBean.setCodingUnit(req.getParameter("location"));
        newUserBean.setUserType(req.getParameter("entryLevel"));
        newUserBean.setUserStatus("Pending");
        
        return newUserBean;
    }
   
        
}
