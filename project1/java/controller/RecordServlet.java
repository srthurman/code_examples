//Sara
package controller;

import web.dbbean.RecordBean;
import web.dbbean.RefListBean;
import web.dbbean.UserBean;
import web.dbbean.compAddrBean;
import web.model.RecordManager;
import web.model.ReferenceList;

import java.io.IOException;
import java.io.InputStream;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class CS extends HttpServlet {
    public CS() {
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
        RecordBean queBean = new RecordBean();
        RecordBean RecBean = new RecordBean();
        compAddrBean compBean = new compAddrBean();
        RecordManager rm = new RecordManager();
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

            if (sess.getAttribute("userBean") != null) {
                userBean = (UserBean)sess.getAttribute("userBean");
            }
            if (sess.getAttribute("queBean") != null) {
                queBean = (RecordBean)sess.getAttribute("queBean");
            }
            if (sess.getAttribute("RecBean") != null) {
                RecBean = (RecordBean)sess.getAttribute("RecBean");
            }
            if (sess.getAttribute("refBean") != null) {
                refBean = (RefListBean)sess.getAttribute("refBean");
            }
            if (sess.getAttribute("phonecallTypes") == null) {
                ArrayList<RefListBean> phonecallTypes = refList.getPhonecallTypes(getDataSource);
                sess.setAttribute("phonecallTypes", phonecallTypes);
            }

            if (action.equals("getAddrRecord")) {
                System.out.println("getAddrRecord: " + queBean.getCustid());
                System.out.println("getAddrRecord qaCycle: " + queBean.getQaCycle());
                // Added by Shashi to get Address record including the corrected data from db.
                RecBean = rm.getAddressRecord(getDataSource, queBean, RecBean);
                compBean = rm.getCompAddr(getDataSource, RecBean);
                
                System.out.println("CS: getAddressRecord : " + RecBean.getCustid());
                if (RecBean.getRetStatus() == 0) {
                    if (queBean.getQaCycle().equals("2")) {
                        System.out.println("getAddrRecord set manual status");
                        manualStatus = rm.checkManualStatus(getDataSource, queBean);
                        sess.setAttribute("manualStatus", manualStatus);
                    }
                    sess.setAttribute("RecBean", RecBean);
                    sess.setAttribute("ssBean", compBean);
                    sess.setAttribute("recType", "record");
                    redirect = "/jsp/xyz_record.jsp";
                    queBean.setProdTimeType("O");
                    rm.UpdateProdTime(getDataSource, queBean);
                } else {
                    errorMessage = errorProp.getProperty("AddrRec_error", queBean.getCustid());
                    redirect = "/jsp/xyz_menu.jsp";
                }

            } else if (action.equals("checkManualStatus")) {
                manualStatus = rm.checkManualStatus(getDataSource, queBean);
                results.append(manualStatus);
                res.getWriter().write(results.toString());
                return;

            } else if (action.equals("Reset")) {
                sess.removeAttribute("refBean");
                sess.removeAttribute("blockID");
                resultsBlk.append("");
                res.getWriter().write(resultsBlk.toString());
                return;

            } else if (action.equals("ExitRecord")) {
                queBean.setProdTimeType("C");
                rm.UpdateProdTime(getDataSource, queBean);
                sess.removeAttribute("refBean");
                sess.removeAttribute("blockID");
                sess.removeAttribute("queBean");
                sess.removeAttribute("RecBean");
                sess.removeAttribute("manualStatus");
                sess.removeAttribute("recType");
                sess.removeAttribute("qaCycle");
                redirect = "/loginProcess?action=verifyLogin";
            } else if (action.equals("saveCorrInfo")) {
                boolean updateSuccessful;

                RecBean.setCorrAddrNumber(req.getParameter("corrHn"));
                RecBean.setCorrStreetName(req.getParameter("corrStreetName"));
                RecBean.setCorrUnitInfo(req.getParameter("corrUnitNo"));
                RecBean.setCorrCity(req.getParameter("corrCity"));
                RecBean.setCorrState(req.getParameter("corrState"));
                RecBean.setCorrZip(req.getParameter("corrZipCode"));
                RecBean.setCorrMailnoncity(req.getParameter("corrNonCityAddr"));
                RecBean.setCorrMailPOBox(req.getParameter("corrPoBox"));
                RecBean.setCorrLocdesc(req.getParameter("corrLocDesc"));
                RecBean.setCorrResponseNameFirst(req.getParameter("corrNameFirst"));
                RecBean.setCorrResponseNameMiddle(req.getParameter("corrNameMiddle"));
                RecBean.setCorrResponseNameLast(req.getParameter("corrNameLast"));
                RecBean.setCorrResponsePhoneArea(req.getParameter("corrRespPhoneArea"));
                RecBean.setCorrResponsePhonePrefix(req.getParameter("corrRespPhonePrefix"));
                RecBean.setCorrResponsePhoneSuffix(req.getParameter("corrRespPhoneSuffix"));
                RecBean.setNotes(req.getParameter("recNotes"));
                RecBean.setManualPhoneCall(req.getParameter("phoneCallRecord"));

                //                System.out.println("PhoneCallRecord: "+req.getParameter("phoneCallRecord"));

                updateSuccessful = rm.updateCorrectedInfo(getDataSource, RecBean);
                if (updateSuccessful) {
                    retStatus = 0;
                    errorMessage = errorProp.getProperty("address_update_success");
                } else {
                    retStatus = 1;
                    errorMessage = errorProp.getProperty("address_update_Error", RecBean.getCustid());
                }
                System.out.println("saveCorrInfo UpdateSuccessful: " + updateSuccessful);

                results.append(retStatus + ":" + errorMessage);
                res.getWriter().write(results.toString());
                return;
            } else if (action.equals("showMap")) {
                redirect = "/jsp/xyz_map.jsp";
            } else if (action.equals("importBlockID")) {
                String blockID = req.getParameter("blockID");
                if (blockID != null) {

                    String blockSt = "";
                    String blockCou = "";
                    String blockTract = "";
                    String blockBlock = "";

                    blockSt = blockID.substring(0, 2);
                    blockCou = blockID.substring(2, 5);
                    blockTract = blockID.substring(5, 11);
                    blockBlock = blockID.substring(11);

                    //will need to remove this attribute on navigating away from the page
                    System.out.println(blockID);
                    sess.setAttribute("blockID", blockID);
                    retStatus = 0;
                    errorMessage = errorProp.getProperty("Map_block_selected");
                    resultsBlk.append(retStatus + ":" + errorMessage + ":" + blockSt + ":" + blockCou + ":" +
                                      blockTract + ":" + blockBlock);
                } else {
                    System.out.println("No blockID");
                    retStatus = 1;
                    errorMessage = errorProp.getProperty("Map_no_block_selected");
                    resultsBlk.append(retStatus + ":" + errorMessage);
                }

                //                resultsBlk.append(retStatus + ":" + errorMessage);
                res.getWriter().write(resultsBlk.toString());
                return;
            } else if (action.equals("AddressSearch")) {
                System.out.println("addressSearch");
                sess.removeAttribute("refBean");

                refBean.setSelHn(refList.emptyIfNull(req.getParameter("selHn")));
                refBean.setSelStreet(refList.emptyIfNull(req.getParameter("selStreet")));
                refBean.setSelIntStreet(refList.emptyIfNull(req.getParameter("selIntStreet")));
                refBean.setSelZip(refList.emptyIfNull(req.getParameter("selZip")));
                refBean.setSelSt(refList.emptyIfNull(req.getParameter("selSt")));
                refBean.setSelCou(refList.emptyIfNull(req.getParameter("selCou")));
                refBean.setSelBlock(refList.emptyIfNull(req.getParameter("selBlock")));
                refBean.setSelTract(refList.emptyIfNull(req.getParameter("selTract")));

                if ((!refBean.getSelStreet().isEmpty() && !refBean.getSelZip().isEmpty()) ||
                    (!refBean.getSelSt().isEmpty() && !refBean.getSelCou().isEmpty() &&
                     !refBean.getSelBlock().isEmpty() && !refBean.getSelTract().isEmpty())) {
                    refList.getAddrNameList(getDataSource, refBean);
                    refList.getAddrRangeNameList(getDataSource, refBean);
                } else {
                    refBean = new RefListBean();
                    refBean.setSelZip(refList.emptyIfNull(req.getParameter("selZip")));
                }
                sess.setAttribute("refBean", refBean);
                System.out.println("addressSearch - set redirect");
                redirect = "/jsp/xyz_navResults.jsp";

            } else if (action.equals("AddrRangeList")) {
                refBean.getArList().clear();
                sess.setAttribute("selRow",
                                  req.getParameter("selRow")); //attribute to retain the selected row while switch range pages
                refBean.setSelDisplayName(refList.emptyIfNull(req.getParameter("selDisplayName")));
                refBean.setSelArZip(refList.emptyIfNull(req.getParameter("selArZip")));
                refBean.setSelParity(refList.emptyIfNull(req.getParameter("selParity")));

                refList.getAddrRangeList(getDataSource, refBean);
                sess.setAttribute("refBean", refBean);
                // redirect = "/jsp/xyz_rangeResults2.jsp";
                redirect = "/jsp/xyz_navResults.jsp";

            } else if (action.equals("RecordRefer")) {

                int updateRefer = 0;

                updateRefer = rm.updateRefer(getDataSource, queBean);
                if (updateRefer == 0) {
                    errorMessage = errorProp.getProperty("refer_success");
                    queBean.setProdTimeType("C");
                    rm.UpdateProdTime(getDataSource, queBean);
                } else {
                    errorMessage = errorProp.getProperty("refer_Error", queBean.getCustid());
                }
                System.out.print("updateRefer Status: " + updateRefer);

                results.append(updateRefer + ":" + errorMessage);
                res.getWriter().write(results.toString());
                return;
            } else if (action.equals("RecordUncodable")) {

                int updateUncodable = 0;

                updateUncodable = rm.updateUncodable(getDataSource, queBean);
                if (updateUncodable == 0) {
                    errorMessage = errorProp.getProperty("uncodable_success");
                    queBean.setProdTimeType("C");
                    rm.UpdateProdTime(getDataSource, queBean);
                } else {
                    errorMessage = errorProp.getProperty("uncodable_error", RecBean.getCustid());
                }
                System.out.print("updateUncodable: " + updateUncodable);
                results.append(updateUncodable + ":" + errorMessage);
                res.getWriter().write(results.toString());
                return;

            } else if (action.equals("RecordAccept")) {
                int updateAccept = 0;
                String selCodedDataAndType = req.getParameter("selCodedTypeAndData");

                updateAccept = rm.updateAccept(getDataSource, queBean, selCodedDataAndType);
                if (updateAccept == 0) {
                    errorMessage = errorProp.getProperty("accept_success");
                    queBean.setProdTimeType("C");
                    rm.UpdateProdTime(getDataSource, queBean);
                } else {
                    errorMessage = errorProp.getProperty("accept_error", RecBean.getCustid());
                }
                System.out.print("updateAccept: " + updateAccept);
                results.append(updateAccept + ":" + errorMessage);
                res.getWriter().write(results.toString());
                return;

            } else if (action.equals("retrieveQCList")) {
                System.out.println("action retrieveQCList");
                boolean retrieveSuccess;
                boolean retrieveQCInfo;
                RecordBean qcBean = new RecordBean();
                ArrayList<RecordBean> qcList = new ArrayList<RecordBean>();

                retrieveSuccess = rm.updateQueueInfo(getDataSource, RecBean);
                System.out.println("queBean: " + queBean.getQaCycle() + " " + queBean.getBundleId() + " " +
                                   queBean.getCustid());
                if (retrieveSuccess) {

                    qcBean = rm.retrieveQCRecord(getDataSource, queBean);
                    qcList = rm.retrieveQCList(getDataSource, queBean);


                    System.out.println("what is qcBean " + qcBean);

                    queBean.setProdTimeType("C");
                    rm.UpdateProdTime(getDataSource, queBean);
                    if (qcBean != null) {
                        sess.setAttribute("qcBean", qcBean);
                        sess.setAttribute("qcList", qcList);
                        redirect = "/jsp/xyz_QCList.jsp";
                    } else {
                        errorMessage = errorProp.getProperty("QC_error");
                        req.setAttribute("errorMessage", errorMessage);
                        redirect = "/jsp/xyz_ErrorPage.jsp";
                    }
                } else {
                    System.out.println("CS - retrieveQCList - Error");
                }
            } else if (action.equals("retQCRec")) {
                sess.removeAttribute("refBean");
                System.out.println("action:  retQCRec");
                String selQCRow = (rm.emptyIfNull(req.getParameter("selQCRow")));
                String[] split = selQCRow.split(":");
                String custId = split[0];
                String QaCycle = split[1];
                String BundleId = split[2];

                System.out.println("retQCRec custId: " + custId);
                System.out.println("retQCRec qaCycle: " + QaCycle);
                System.out.println("retQCRec BundleId: " + BundleId);
                queBean.setCustid(custId);

                RecBean = rm.getAddressRecord(getDataSource, queBean, RecBean);
                compBean = rm.getCompAddr(getDataSource, RecBean);
        
                System.out.println("CS: getAddressRecord : " + RecBean.getCustid());

                if (RecBean.getRetStatus() == 0) {
                    if (queBean.getQaCycle().equals("2")) {
                        System.out.println("getAddrRecord set manual status");
                        manualStatus = rm.checkManualStatus(getDataSource, queBean);
                        sess.setAttribute("manualStatus", manualStatus);
                    }
                    queBean.setProdTimeType("O");
                    rm.UpdateProdTime(getDataSource, queBean);
                    sess.setAttribute("RecBean", RecBean);
                    sess.setAttribute("ssBean", compBean);
                    redirect = "/jsp/xyz_record.jsp";
                } else {
                    System.out.println("CS - retQCRec - Error");
                    errorMessage = errorProp.getProperty("AddrRec_error", queBean.getCustid());
                    redirect = "/jsp/xyz_menu.jsp";
                }
            } else if (action.equals("updateQueueTableQC")) {
                String updateQue = "";
                String errorFlag = req.getParameter("errorFlag");

                updateQue = rm.updateQueueTableQC(getDataSource, queBean, errorFlag);
                queBean.setProdTimeType("C");
                rm.UpdateProdTime(getDataSource, queBean);
                if (updateQue.equals("0")) {
                    redirect = "/CS?action=checkLastCase";
                } else {
                    System.out.println("CS - updateQueueTableQC - Error");
                    ///// Add this error message
                    errorMessage = errorProp.getProperty("Queue_update_error");
                    redirect = "/jsp/xyz_menu.jsp";
                }
            } else if (action.equals("checkLastCase")) {
                String lastCase = rm.checkLastQCCase(getDataSource, queBean);

                if (lastCase.equals("1")) {
                    redirect = "/ControlServlet?action=getNewRecord&qaCycle=2";
                } else if (lastCase.equals("0")) {
                    rm.updateQCBundle(getDataSource, queBean);
                    redirect = "/CS?action=ExitRecord";
                }
            } else if (action.equals("compareQCRecords")) {
                String compareStatus = "";
                String compareResults = rm.compareQCRecords(getDataSource, RecBean);
                System.out.println("CS - compareQCRecords: "+ compareResults);
                if (compareResults.equals("0")) {
                    rm.updateQueueTableQC(getDataSource, queBean, "0");
                    compareStatus = "0";
                } else if (compareResults.equals("1")) {
                    compareStatus = "1";
                } else {
                    //should we stay on this page or redirect?
                    System.out.println("CS - compareQCRecords - Error");
///// Add this error message
                    errorMessage = errorProp.getProperty("compare_qc_error");
                    compareStatus = "99";
                }
                
                System.out.print("compareStatus: " + compareStatus);
                results.append(compareStatus + ":" + errorMessage);
                res.getWriter().write(results.toString());
                return;

            }
            else if (action.equals("getSideBySide")) {
                compBean = rm.getCompAddr(getDataSource, RecBean);
                sess.setAttribute("ssBean", compBean);
                System.out.println("getAddrRecord set manual status");
                manualStatus = rm.checkManualStatus(getDataSource, queBean);
                sess.setAttribute("manualStatus", manualStatus);
                redirect = "/jsp/xyz_record.jsp";
            }
            else if (action.equals("QCPhoneCall")) {
                boolean updateSuccessful = rm.QCPhoneCall(getDataSource, RecBean);
                results.append(updateSuccessful);
                res.getWriter().write(results.toString());
                return;
            }
            else if (action.equals("availQCCaseCount")) {
                String userName = req.getParameter("userName");
                System.out.println("Getting available QC case count for: " + userName);
                int availableCases = rm.checkCasesAvailableForQc(getDataSource, userName);
                results.append(availableCases);
                res.getWriter().write(results.toString());
                return;
            }
            else if (action.equals("createQCBundleManual")) {
                String qaSize = req.getParameter("qaSize");
                
                RecordBean manualQCBean = new RecordBean();
                manualQCBean.setUsername(req.getParameter("userName"));
                
                System.out.println("Creating QC Bundle Manually for " + manualQCBean.getUsername() 
                    + " using " + qaSize + " records.");
                
                retStatus = rm.CreateQcBundle(getDataSource, manualQCBean, qaSize);
                
                if (retStatus == 0) {
                    errorMessage = errorProp.getProperty("create_qc_bundle_success");
                } else {
                    errorMessage = errorProp.getProperty("create_qc_bundle_fail");
                }
                results.append(retStatus + ":" + errorMessage);
                res.getWriter().write(results.toString());
                return;
            }
            else if (action.equals("logout")) {
                //update the Prod time before invalidate the Session
                queBean.setProdTimeType("C");
                rm.UpdateProdTime(getDataSource, queBean);

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
            System.out.println("Error in CS: action -" + action);
            ee.printStackTrace();
            String str = ee.getMessage();
            errorMessage = "CS Exception : " + str;
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
