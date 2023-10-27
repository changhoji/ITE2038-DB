<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="proj1.*" %> <%@ page
import="java.util.ArrayList" %> <%@ include file="global.jsp" %>
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" href="css/common.css" />
    <link rel="stylesheet" href="css/login.css" />
    <title>JSP - Hello World</title>
  </head>
  <body>
    <header></header>
    <article>
      <% attributes = (Attribute) request.getAttribute("attb"); if (attributes
      != null && attributes.getMessage() != null) {%>
      <script>window.setTimeout(()=>{alert('<%=attributes.getMessage()%>')}, 100)</script>
    <% } %>
    </article>
    <main>
      <form id="input-login" action="form.jsp" method="post">
        <input type="text" name="before-page" value="login" class="hidden" />
        <input type="text" name="state" value="login" class="hidden" />
          <label for="input-id">아이디 입력</label>
          <input
            type="text"
            class="input-text"
            id="input-id"
            name="id"
            placeholder="아이디"
          />
          <label for="input-pw">비밀번호 입력</label>
          <input
            type="text"
            class="input-text"
            id="input-pw"
            name="pw"
            placeholder="비밀번호"
          />
        <div id="login-submit">
          <input type="submit" id="submit-button" value="로그인" />
        </div>
      </form>
    </main>
    <footer></footer>
  </body>
</html>
