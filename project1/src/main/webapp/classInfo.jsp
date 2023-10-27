<%--
  Created by IntelliJ IDEA.
  User: onkkn
  Date: 2022-11-02
  Time: 오전 12:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="proj1.*" %>
<%@ include file="global.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Array" %>
<html>
<head>
    <link rel="stylesheet" href="css/common.css">
    <title>classInfo</title>
</head>
<body>
<%
    attributes = (Attribute) request.getAttribute("attb");
    ClassDTO c = dao.getClasses("WHERE class_id="+attributes.getClassId()).get(0);
%>
<header>수강신청 페이지</header>
<article>
    <% if (attributes.getMessage() != null) out.println(attributes.getMessage()); %>
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
    <table>
        <thead>
        <th>수업번호</th>
        <th>학수번호</th>
        <th>교과목명</th>
        <th>교강사이름</th>
        <th>강의실</th>
        <th>강의실 정원</th>
        <th>신청 / 정원</th>
        <th>강의년도</th>
        <th>강의시간</th>
        </thead>
        <tbody>
        <tr>
            <td><%=c.getClassId()%></td>
            <td><%=c.getCourseId()%></td>
            <td><%=c.getName()%></td>
            <td><%=c.getLecturerName()%></td>
            <td><%=c.getBuildingName()+"("+c.getRoomId()+")"%></td>
            <td><%=c.getOccupancy()%></td>
            <td><%=c.getEnrolled()+"/"+c.getPersonMax()%></td>
            <td><%=c.getOpened()%></td>
<%          out.println("<td>");
            if (c.iseLearning()) { //수업이 e러닝 강의면 그렇게 출력
                out.println("E-러닝");
            }
            else { //아니면 시간을 출력
                for (ClassTime t : c.getTimes()) {
                    out.println("<p>" + t.toString() + "</p>");
                }
                out.println("</td>");
            } %>
        </tr>
        </tbody>
    </table>
    <div id="modify-class-field">
        <div id="change-person-max">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="changePersonMax" class="hidden">
                <input type="text" name="before-page" value="classInfo" class="hidden">
                <input type="text" name="class-id" value="<%=c.getClassId()%>" class="hidden">
                <label for="newPersonMax">바꿀 수강정원: </label>
                <input type="text" name="newPersonMax" id="newPersonMax">
                <input type="submit" value="변경">
            </form>
        </div>
        <div id="insert-student">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="insertStudent" class="hidden">
                <input type="text" name="before-page" value="classInfo" class="hidden">
                <input type="text" name="class-id" value="<%=c.getClassId()%>" class="hidden">
                <label for="student-id">추가할 학생의 학번 </label>
                <input type="text" name="student-id" id="student-id">
                <input type="submit" value="변경">
            </form>
        </div>
        <div id="delete-class">
            <form action="form.jsp" method="post">
                <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
                <input type="text" name="state" value="deleteClass" class="hidden">
                <input type="text" name="before-page" value="classInfo" class="hidden">
                <input type="text" name="class-id" value="<%=c.getClassId()%>" class="hidden">
                <input type="submit" value="수업삭제">
            </form>
        </div>
    </div>
</main>
<footer></footer>

</body>
</html>
