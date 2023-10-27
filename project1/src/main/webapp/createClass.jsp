<%--
  Created by IntelliJ IDEA.
  User: onkkn
  Date: 2022-11-02
  Time: 오후 7:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="proj1.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="global.jsp" %>
<html>
<head>
  <link rel="stylesheet" href="css/createClass.css">
  <link rel="stylesheet" href="css/common.css">
    <title>createclass</title>
</head>
<body>
<%
  attributes = (Attribute) request.getAttribute("attb");
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
  <div id="create-class-field">
    <form action="form.jsp" method="post">
      <input type="text" name="user-id" value="<%=attributes.getUserId()%>" class="hidden">
      <input type="text" name="before-page" value="createClass" class="hidden">
      <input type="text" name="state" value="general" class="hidden">
      <label for="classNo">수업번호</label><input type="text" id="classNo" name="classNo"><br>
      <label for="majorId">전공id</label><input type="text" id="majorId" name="majorId"><br>
      <label for="name">수업이름</label><input type="text" id="name" name="name"><br>
      <label for="credit">학점</label><input type="text" id="credit" name="credit"><br>
      <label for="year">학년</label><input type="text" id="year" name="year"><br>
      <label for="lecturerId">교강사학번</label><input type="text" id="lecturerId" name="lecturerId"><br>
      <label for="personMax">수강정원</label><input type="text" id="personMax" name="personMax"><br>
      <label for="roomId">강의실</label><input type="text" id="roomId" name="roomId"><br>
      <label for="time">시간</label><input type="text" id="time" name="time"><br>
      <input type="submit" value="추가">
    </form>
  </div>
</main>
</body>
</html>
