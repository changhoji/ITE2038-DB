<%--
  Created by IntelliJ IDEA.
  User: onkkn
  Date: 2022-10-19
  Time: 오후 4:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="proj1.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="global.jsp" %>
<html>
    <head>
        <meta charset="UTF-8">
    
        <link rel="stylesheet" href="css/common.css">
        <link rel="stylesheet" href="css/main.css">
        <title>main</title>
    </head>
    <body>
    <% //attributes에 userId, isAdmin, (student), classes가 있어야 함
        attributes = (Attribute) request.getAttribute("attb");
        state = attributes.getState();
        request.setAttribute("attb", attributes);

        ArrayList<ClassDTO> classes = attributes.getClasses();

        //class 목록을 검색 조건에 맞춰 불러오기
    %>

    <header>
        수강신청 페이지
    </header>
    <article>
        <% if (attributes.getMessage() != null) { //getMessage가 있다면 alert로 표시 %>
        <script>window.setTimeout(function() {alert('<%=attributes.getMessage()%>')}, 300)</script>
        <% } %>
    </article>
    <nav>
        <div class="nav-link">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="general" class="hidden">
                <input type="text" name="nav" value="main" class="hidden">
                <input type="submit" value="수강편람">
            </form>
        </div>
        <%
            if (attributes.getIsAdmin()) { //관리자 nav 목록
        %>
<%--        admin일때 nav 표시--%>
        <div class="nav-link">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="general" class="hidden">
                <input type="text" name="nav" value="studentInfo" class="hidden">
                <input type="submit" value="학생 정보">
            </form>
        </div>

        <div class="nav-link">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="general" class="hidden">
                <input type="text" name="nav" value="statistics" class="hidden">
                <input type="submit" value="통계 확인">
            </form>
        </div>

        <div class="nav-link">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="general" class="hidden">
                <input type="text" name="nav" value="createClass" class="hidden">
                <input type="submit" value="수업 설강">
            </form>
        </div>

        [Admin]
<%--        admin일때 nav 표시--%>
        <%
            } else { //학생 nav 목록
        %>
<%--        admin이 아닐대 nav 표시--%>
        <div class="nav-link">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="general" class="hidden">
                <input type="text" name="nav" value="studentInfo" class="hidden">
                <input type="submit" value="내 정보">
            </form>
        </div>

        <div id="student-id-name">
            <%=attributes.getStudent().getStudentId()+"("+attributes.getStudent().getName()+")"%>
        </div>

        <div id="student-credit-sum">
            <%="(신청: "+attributes.getStudent().getCreditSum()+"학점)"%>
        </div>
<%--        admin이 아닐때 nav 표시--%>
        <%
            }
        %>
        <div class="nav-link">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="toLogin" class="hidden">
                <input type="text" name="nav" value="studentInfo" class="hidden">
                <input type="submit" value="로그아웃">
            </form>
        </div>
    </nav>

    <main>
<%--    수강편람 검색 기능 begin --%>
    <%--    수업번호, 학수번호, 교과목명, 년도 검색 begin --%>
        <div class="search-input">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <div>
                    <label>검색조건 선택</label>
                    <input type="text" value="search-class" name="state" class="hidden">
                    <input type="text" value="main" name="before-page" class="hidden">
                    <%-- 수업번호, 학수번호, 교과목명 중에서는 한가지로만 검색 가능하게 함 --%>
                    <select name="search-select">
                        <option value="class_no">수업번호</option>
                        <option value="course_id">학수번호</option>
                        <option value="class.name">교과목명</option>
                    </select>
                    <label for="search-condition-value">검색내용: </label>
                    <input type="text" name="search-value" id="search-condition-value" placeholder="없음">
                </div>
                <div>
                    <label>년도선택</label>
                    <select name="year" id="year-select">
                        <option value="2022">2022년</option>
                        <option value="2021">2021년</option>
                        <option value="2020">2020년</option>
                        <option value="2019">2019년</option>
                        <option value="전체">전체</option>
                    </select>
                </div>
                <input type="submit">
            </form>
        </div>
    <%--    수업번호, 학수번호, 교과목명, 년도 검색 end  --%>

    <div class="search-condition">
    <%--    전체 보기 begin--%>
        <div>
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" value="main" name="before-page" class="hidden">
                <input type="text" value="all" name="state" class="hidden">
                <input type="submit" value="전체 검색">
            </form>
        </div>
    <%--    전체 보기 end --%>

    <%--    지정과목, 희망수업, 신청수업 보기 begin --%>
<%  if (!attributes.getIsAdmin()) { //학생일때만 지정과목, 희망수업, 신청수업 보기 %>
    <%--    지정과목 보기 begin --%>
        <div>
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" value="main" name="before-page" class="hidden">
                <input type="text" value="my" name="state" class="hidden">
                <input type="submit" value="지정과목">
            </form>
        </div>
    <%--    지정과목 보기 end --%>

    <%--    희망수업 보기 begin --%>
        <div>
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" value="main" name="before-page" class="hidden">
                <input type="text" value="wish" name="state" class="hidden">
                <input type="submit" value="희망수업">
            </form>
        </div>
    <%--    희망수업 보기 end --%>

    <%--    신청수업 보기 begin --%>
        <div>
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" value="main" name="before-page" class="hidden">
                <input type="text" value="enroll" name="state" class="hidden">
                <input type="submit" value="신청수업">
            </form>
        </div>
    <%--    신청수업 보기 end --%>
<%  } %>
    <%--    지정과목, 희망수업, 신청수업 보기 end --%>
    </div>
<%--    수강편람 검색기능 end --%>

<%--    수업목록 표시 begin --%>
        <table>
            <thead><tr>
            <th>수업번호</th>
            <th>학수번호</th>
            <th>교과목명</th>
            <th>교강사이름</th>
            <th>강의실</th>
            <th>신청 / 정원</th>
            <th>강의년도</th>
            <th>강의시간</th>
    <%  if (attributes.getIsAdmin()) { // 관리자일때 표시 %>
            <th>수업편집</th>
    <% } else { // 학생일때 표시 %>
            <th>희망추가</th>
            <th>수강신청</th>
            </tr></thead>
            <tbody>
    <% }
                for (ClassDTO c: classes) {
                    out.println("<tr><td>"+c.getClassNo()+"</td>");
                    out.println("<td>"+c.getCourseId()+"</td>");
                    out.println("<td>"+c.getName()+"</td>");
                    out.println("<td>"+c.getLecturerName()+"</td>");
                    out.println("<td>"+c.getBuildingName()+"("+c.getRoomId()+")</td>");
                    if (c.getYear() != 2022)
                        out.println("<td>"+c.getEnrolled()+"/"+c.getPersonMax()+"</td>");
                    else
                        out.println("<td>00</td>");
                    out.println("<td>"+c.getOpened()+"</td>");
                    out.println("<td>"); //강의시간
                    if (c.iseLearning()) { //수업이 e러닝 강의면 그렇게 출력
                        out.println("E-러닝");
                    }
                    else { //아니면 시간을 출력
                        for (ClassTime t : c.getTimes()) {
                            out.println("<p>" + t.toString() + "</p>");
                        }
                        out.println("</td>");
                    }

                    if (!attributes.getIsAdmin()) { //학생이면 희망, 신청 버튼
                        out.print("<td>" + dao.wishString(attributes, c, state) + "</td>");
                        out.print("<td>" + dao.enrollString(attributes, c, state) + "</td></tr>");

                    } else {
                        out.println("<td>");//관리자면 수정 버튼
                        if (c.getOpened() == 2022) { %>
                            <form action="form.jsp" method="action">
                                <input type="text" name="state" value="modifyClass" class="hidden">
                                <input type="text" name="before-page" value="main" class="hidden">
                                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                                <input type="text" name="class-id" value="<%=c.getClassId()%>" class="hidden">
                                <input type="submit" value="수정">
                            </form>
                        <%  }
                        out.println("</td>");
                      }
                     %>
                </tr>
                <%  } %>
            </tbody>
        </table>
<%--    수업목록 표시 end --%>
    </main>

    <footer>

    </footer>
    </body>
</html>
