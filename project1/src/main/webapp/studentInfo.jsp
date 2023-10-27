<%--
  Created by IntelliJ IDEA.
  User: onkkn
  Date: 2022-10-31
  Time: 오후 11:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="proj1.*" %>
<%@ page import="java.util.*" %>
<%@ include file="global.jsp" %>
<html>
<head>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/studentInfo.css">
    <title>Title</title>
</head>
<body>
<%
    attributes = (Attribute) request.getAttribute("attb");
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
<%
    if (attributes.getIsAdmin() ) { %>
        <form action="form.jsp" method="post">
            <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
            <input type="text" name="state" value="searchStudent" class="hidden">
            <input type="text" name="before-page" value="studentInfo" class="hidden">
            <label for="studentId">검색할 학생 학번: </label>
            <input type="text" name="studentId" id="studentId">
            <input type="submit" value="확인">
        </form>
<%  } %>
<%--학생 정보 표시 및 수정 필드 begin --%>
<%  if (!attributes.getState().equals("select")) {  %>
    <div id="student-info-field">
        <div class="student-id">
            <div class="key">
                학번
            </div>
            <div class="value">
                <%=attributes.getStudent().getStudentId()%>
            </div>
        </div>
        <div class="student-name">
            <div class="key">
                이름
            </div>
            <div class="value">
                <%=attributes.getStudent().getName()%>
            </div>
        </div>
        <div class="lecturer-name">
            <div class="key">
                지도교수
            </div>
            <div class="value">
                <%=attributes.getStudent().getLecturerName()%>
            </div>
        </div>
        <div class="major">
            <div class="key">
                전공
            </div>
            <div class="value">
                <%=attributes.getStudent().getMajorName()%>
            </div>
        </div>
        <div class="student-year">
            <div class="key">
                학년
            </div>
            <div class="value">
                <%=attributes.getStudent().getYear()%>
            </div>
        </div>
        <div class="student-state">
            <div class="key">
                학생상태
            </div>
            <div class="value">
                <%=attributes.getStudent().getState()%>
            </div>
        </div>
        <% if (!attributes.getIsAdmin()) { //학생일때는 아이디와 비밀번호 변경기능 %>
        <div class="change-id">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="changId" class="hidden">
                <input type="text" name="before-page" value="studentInfo" class="hidden">
                <label for="newId">바꿀 아이디: </label>
                <input type="text" name="newId" id="newId">
                <input type="submit" value="변경">
            </form>
        </div>
        <div class="change-password">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="changePw" class="hidden">
                <input type="text" name="before-page" value="studentInfo" class="hidden">
                <label for="newPw">바꿀 비밀번호: </label>
                <input type="text" name="newPw" id="newPw">
                <input type="submit" value="변경">
            </form>
        </div>
        <% } else { //관리자일때는 학생의 state 변경기능 %>
        <div class="change-password">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="changeState" class="hidden">
                <input type="text" name="before-page" value="studentInfo" class="hidden">
                <label for="newState">바꿀 상태: </label>
                <input type="text" name="newState" id="newState">
                <input type="submit" value="변경">
            </form>
        </div>
        <% } %>
    </div>

<%--학생 정보 표시 및 수정 필드 end --%>

<%--시간표 표시 begin --%>
<%  if (attributes.getIsAdmin()) {  //admin일때 학생의 성적들 표시
        ArrayList<CreditsDTO> credits = dao.getCredits(attributes.getStudent().getStudentId()); %>
    <div id="student-credits-field">
        <table>
            <thead><tr>
                <th>학수번호</th>
                <th>과목이름</th>
                <th>수강년도</th>
                <th>성적</th>
                <th>학점</th>
            </tr></thead>
            <tbody>
        <%  for (CreditsDTO cd: credits) { //각각의 성적에 대해 table에 추가 %>
            <tr>
                <td><%=cd.getCourseId()%></td>
                <td><%=cd.getCourseName()%></td>
                <td><%=cd.getYear()%></td>
                <td><%=cd.getGrade()%></td>
                <td><%=cd.getCredit()%></td>
            </tr>
        <%  }  %>
            </tbody>
        </table>
    </div>

<%  } %>
    <div id="time-table-field">
        <table>
            <tr>
                <th>시간</th>
                <th>월</th>
                <th>화</th>
                <th>수</th>
                <th>목</th>
                <th>금</th>
                <th>토</th>
            </tr>
            <%
                for (int row = 0; row < 24; row++) { //시간
                    int t = 8*60+30*row;
                    int h = t/60;
                    int m = t%60;

                    out.println("<tr>");
                    out.println(String.format("<td>%02d시%02d분</td>", h, m));
                    ArrayList<String> days = new ArrayList<String>();
                    days.add("월");
                    days.add("화");
                    days.add("수");
                    days.add("목");
                    days.add("금");
                    days.add("토");

                    for (int col = 0; col < 6; col++) { //요일
                        out.println("<td>"+dao.showTable(attributes.getStudent().getStudentId(), row, days.get(col))+"</td>");
                    }
                    out.println("</tr>");
                }

            %>
        </table>
    </div>
<%  } %>
<%--시간표 표시 end--%>

</main>
</body>
</html>
