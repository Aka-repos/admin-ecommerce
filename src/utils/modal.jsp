<%-- modal.jsp - Archivo de modales reutilizable con validación --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- MODAL PRINCIPAL LOGIN -->
<div class="modal-overlay" style="display:none;">
  <div class="modal-content">
    <button class="close-modal">✖</button>
    <div class="modal-box">
      <div class="modal-image">
        <img src="img/imginicio/modal.jpeg" alt="Decoración" />
      </div>
      <div class="modal-form">
        <h2 class="login-title">Iniciar Sesión</h2>
        <!-- FORMULARIO CONECTADO A LA BASE DE DATOS -->
        <form action="validarLogin.jsp" method="post">
          <div class="input-group">
            <span class="input-icon">📧</span>
            <input type="text" name="usuario" placeholder="Usuario o Email" required />
          </div>
          <div class="input-group">
            <span class="input-icon">🔒</span>
            <input type="password" name="clave" placeholder="Contraseña" required />
          </div>
          <button type="submit" class="login-btn">Ingresar</button>
          <div class="extra-links">
            <a href="#" id="btnOpenForgot" class="open-forgot">¿Olvidó su contraseña?</a>
            <a href="#" id="btnOpenRegister" class="open-register">Registrar</a>
          </div>
        </form>
        <div class="modal-social-icons">
          <a href="#" class="icon facebook"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="icon twitter"><i class="fab fa-twitter"></i></a>
          <a href="https://www.instagram.com/pharma.pty/" class="icon instagram"><i class="fab fa-instagram"></i></a>
          <a href="#" class="icon youtube"><i class="fab fa-youtube"></i></a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- MODAL REGISTRO -->
<div class="modal-overlay register-modal" style="display:none;">
  <div class="modal-content">
    <button class="close-modal">✖</button>
    <div class="modal-box">
      <div class="modal-image">
        <img src="img/imginicio/modal.jpeg" alt="Decoración" />
      </div>
      <div class="modal-form">
        <h2 class="login-title">Regístrate</h2>
        <!-- FORMULARIO DE REGISTRO CONECTADO A LA BASE DE DATOS -->
        <form action="registrarUsuario.jsp" method="post">
          <div class="input-group">
            <span class="input-icon">👤</span>
            <input type="text" name="usuario" placeholder="Usuario" required />
          </div>
          <div class="input-group">
            <span class="input-icon">📧</span>
            <input type="email" name="email" placeholder="Correo" required />
          </div>
          <div class="input-group">
            <span class="input-icon">🔒</span>
            <input type="password" name="clave" placeholder="Contraseña" required />
          </div>
          <div class="input-group">
            <span class="input-icon">🔒</span>
            <input type="password" name="confirmar_clave" placeholder="Confirmar contraseña" required />
          </div>
          <button type="submit" class="login-btn">Registrar</button>
          <div class="extra-links">
            <a href="#" id="btnOpenForgotFromRegister" class="open-forgot">¿Olvidó su contraseña?</a>
            <a href="#" id="btnOpenLoginFromRegister" class="open-login">Iniciar sesión</a>
          </div>
          <div class="modal-social-icons">
            <a href="#" class="icon facebook"><i class="fab fa-facebook-f"></i></a>
            <a href="#" class="icon twitter"><i class="fab fa-twitter"></i></a>
            <a href="https://www.instagram.com/pharma.pty/" class="icon instagram"><i class="fab fa-instagram"></i></a>
            <a href="#" class="icon youtube"><i class="fab fa-youtube"></i></a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- MODAL OLVIDÓ CONTRASEÑA -->
<div id="forgotModal" class="modal-overlay" style="display:none;">
  <div class="modal-content modal-olvide">
    <button class="close-modal">✖</button>
    <h2 class="login-title">¿Olvidaste<br>tu contraseña?</h2>
    <form action="recuperarPassword.jsp" method="post">
      <div class="input-group">
        <span class="input-icon">📧</span>
        <input type="email" name="email" placeholder="Correo electrónico" required />
      </div>
      <div style="display:flex; gap:12px; margin-top:20px;">
        <button type="submit" class="login-btn" style="flex:1;">Enviar</button>
        <button type="button" class="login-btn btn-cancel" style="flex:1;">Cancelar</button>
      </div>
      <div class="modal-social-icons">
        <a href="#" class="icon facebook"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="icon twitter"><i class="fab fa-twitter"></i></a>
        <a href="https://www.instagram.com/pharma.pty/" class="icon instagram"><i class="fab fa-instagram"></i></a>
        <a href="#" class="icon youtube"><i class="fab fa-youtube"></i></a>
      </div>
    </form>
  </div>
</div>

<!-- JAVASCRIPT PARA MODALES -->
<script>
document.addEventListener("DOMContentLoaded", () => {
  // Referencias a modales
  const modals = {
    login: document.querySelector(".modal-overlay:not(.register-modal):not(#forgotModal)"),
    register: document.querySelector(".modal-overlay.register-modal"),
    forgot: document.getElementById("forgotModal"),
  };

  // Botones para abrir modales
  const btnOpenLogin = document.getElementById("btnOpenLogin");
  const btnOpenRegister = document.getElementById("btnOpenRegister");
  const btnOpenForgot = document.getElementById("btnOpenForgot");
  const btnOpenForgotFromRegister = document.getElementById("btnOpenForgotFromRegister");
  const btnOpenLoginFromRegister = document.getElementById("btnOpenLoginFromRegister");

  // Funciones para abrir modales
  function openLogin() {
    modals.login.style.display = "flex";
    modals.register.style.display = "none";
    modals.forgot.style.display = "none";
  }
  function openRegister() {
    modals.login.style.display = "none";
    modals.register.style.display = "flex";
    modals.forgot.style.display = "none";
  }
  function openForgot() {
    modals.login.style.display = "none";
    modals.register.style.display = "none";
    modals.forgot.style.display = "flex";
  }

  // Event listeners para abrir modales
  btnOpenLogin?.addEventListener("click", e => {
    e.preventDefault();
    openLogin();
  });
  btnOpenRegister?.addEventListener("click", e => {
    e.preventDefault();
    openRegister();
  });
  btnOpenForgot?.addEventListener("click", e => {
    e.preventDefault();
    openForgot();
  });
  btnOpenForgotFromRegister?.addEventListener("click", e => {
    e.preventDefault();
    openForgot();
  });
  btnOpenLoginFromRegister?.addEventListener("click", e => {
    e.preventDefault();
    openLogin();
  });

  // Cerrar modales con el botón X
  document.querySelectorAll(".close-modal").forEach(btn => {
    btn.addEventListener("click", () => {
      modals.login.style.display = "none";
      modals.register.style.display = "none";
      modals.forgot.style.display = "none";
    });
  });

  // Evitar cierre al hacer clic fuera del contenido modal
  document.querySelectorAll(".modal-overlay").forEach(modal => {
    modal.addEventListener("click", e => {
      if (e.target === modal) {
        e.stopPropagation();
      }
    });
  });

  // Botón cancelar en modal de recuperación de contraseña
  const btnCancelForgot = modals.forgot.querySelector(".btn-cancel");
  btnCancelForgot?.addEventListener("click", e => {
    e.preventDefault();
    modals.forgot.style.display = "none";
  });
});
</script>