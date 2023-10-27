<%--
  Created by IntelliJ IDEA.
  User: onkkn
  Date: 2022-11-02
  Time: 오후 6:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="proj1.*" %>
<%@ include file="global.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Array" %>
<html>
<head>
  <link rel="stylesheet" href="css/statistics.css ">
   <link rel="stylesheet" href="css/common.css">
    <title>Title</title>
</head>
<body>
<%
  Attribute attributes = (Attribute) request.getAttribute("attb");
%>
<header>
  수강신청 페이지
</header>
<article>
  <%
    if (attributes.getMessage() != null) out.println(attributes.getMessage());
  %>
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
    <tr>
      <th>학수번호</th>
      <th>과목이름</th>
      <th>학점</th>
      <th>성적차이지수</th>
    </tr>
  <%
      ArrayList<CourseDTO> courses = dao.getStatistic();
      for (CourseDTO c: courses) { %>
      <tr>
        <td><%=c.getCourseId()%></td>
        <td><%=c.getCourseName()%></td>
        <td><%=c.getCredit()%></td>
        <td><%=c.getDiff()%></td>
      </tr>
  <%  } %>
  </table>
</main>

</body>
</html>
