<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8" />
  <title>PharmaPTY | Tu farmacia en línea</title>
  <link rel="icon" href="img/coazon.png" />
  <link rel="stylesheet" href="home.css" />
  <!-- ICONS: Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>

<body>
  <header class="sticky-header">
    <div class="top-header">
      <div class="logo">
        <img src="img/coazon.png" alt="Logo" />
        <h1 class="typing-effect">
          <span class="pharma">PHARMA</span><span class="pty">PTY</span>
        </h1>
        <a href="https://www.google.com" target="_blank" class="search-btn">
          <i class="fas fa-search"></i>
        </a>
      </div>

      <div class="social-icons">
        <a href="#" class="icon twitter"><i class="fab fa-twitter"></i></a>
        <a href="https://www.instagram.com/pharma.pty/" class="icon instagram"><i class="fab fa-instagram"></i></a>
        <a href="#" class="icon youtube"><i class="fab fa-youtube"></i></a>
        <a href="#" class="icon facebook"><i class="fab fa-facebook-f"></i></a>
      </div>

      <div class="user-cart">
        <!-- Aquí el botón con id único para abrir modal login -->
        <a href="#" id="btnOpenLogin" class="login-btn">
          <i class="fas fa-user"></i> Iniciar sesión
        </a>
        <a href="#" class="cart-btn">
          <i class="fas fa-shopping-cart"></i>
        </a>
      </div>
    </div>

    <nav class="main-nav">
      <a href="home.jsp">Inicio</a>
      <a href="products.jsp">Productos</a>
      <a href="contactus.jsp">Contáctanos</a>
    </nav>
  </header>

  <!-- INCLUIR MODALES -->
  <%@ include file="modal.jsp" %>

    <section class="banner">
      <img src="img/imginicio/pubi1.jpeg" alt="Publicidad PharmaPTY" />
    </section>

    <!-- Texto de Noticias -->
    <section class="headline">
      <h2 class="typing-green">MIRA LAS MEJORES NOTICIAS DE FARMACIA!</h2>
    </section>

    <section class="news-section">
      <!-- Noticia 1 -->
      <div class="news-card">
        <img src="img/imginicio/1.webp" alt="Farmacia rural con robot" />
        <h2>¿Conviene un robot en una farmacia rural?</h2>
        <p>Automatizar una farmacia rural puede parecer innecesario, pero la eficiencia, ahorro de tiempo y precisión en
          la dispensación lo hacen una inversión valiosa incluso en zonas menos pobladas.</p>
        <a class="news-btn" href="https://www.pharmathek.com/es/farmacia-rural-robot-conviene/" target="_blank">Ver
          Noticia</a>
      </div>

      <!-- Noticia 2 -->
      <div class="news-card">
        <img src="img/imginicio/2.jpeg" alt="Automatización y estrés" />
        <h2>La automatización reduce el estrés en la farmacia</h2>
        <p>El uso de robots y sistemas automatizados no solo mejora la eficiencia, también reduce significativamente el
          estrés y la carga mental del equipo farmacéutico.</p>
        <a class="news-btn" href="https://www.pharmathek.com/es/automatizacion-reduce-estres-en-la-farmacia/"
          target="_blank">Ver Noticia</a>
      </div>

      <!-- Video Noticia -->
      <div class="news-card video-card">
        <iframe src="https://www.youtube.com/embed/jsJZUCArOAs" title="Video automatización en farmacia" frameborder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen></iframe>
        <h2>Video: Automatización en farmacias</h2>
        <p>Descubre en este video cómo los robots de farmacia optimizan procesos, reducen tiempos de espera y aumentan
          la precisión del servicio al cliente.</p>
        <a class="news-btn" href="https://youtu.be/jsJZUCArOAs" target="_blank">Ver en YouTube</a>
      </div>

      <!-- Noticia 4 -->
      <div class="news-card">
        <img src="img/imginicio/4.jpg" alt="Tecnología farmacia" />
        <h2>La farmacia del futuro ya está aquí</h2>
        <p>Robots que dispensan medicamentos, apps que controlan recetas y seguimiento del paciente desde casa. Así es
          como se reinventa la farmacia.</p>
        <a class="news-btn" href="https://www.coopfarma.com/noticias/farmacia-del-futuro" target="_blank">Ver
          Noticia</a>
      </div>

      <!-- Noticia 5 -->
      <div class="news-card">
        <img src="img/imginicio/5.jpg" alt="Farmacia online" />
        <h2>Farmacias online: una nueva realidad</h2>
        <p>Las farmacias online están creciendo. La venta de medicamentos con receta y la asesoría en línea son los
          nuevos retos del sector farmacéutico.</p>
        <a class="news-btn" href="https://blog.farmaciasdirect.com/farmacias-online/" target="_blank">Ver Noticia</a>
      </div>

      <!-- Noticia 6 -->
      <div class="news-card">
        <img src="img/imginicio/6.webp" alt="Automatización de procesos" />
        <h2>¿Cómo automatizar procesos en tu farmacia?</h2>
        <p>Desde software de gestión hasta robots para medicamentos: conoce las soluciones tecnológicas disponibles para
          modernizar tu farmacia.</p>
        <a class="news-btn" href="https://saludiario.com/automatizacion-en-farmacias/" target="_blank">Ver Noticia</a>
      </div>
    </section>

    <section class="banner">
      <img src="img/imginicio/publi2.jpeg" alt="Publicidad PharmaPTY" />
    </section>

    <footer class="footer">
      <div class="footer-container">
        <!-- 1. Misión -->
        <div class="footer-column">
          <h3>PharmaPTY</h3>
          <p>PharmaPTY optimiza el suministro de medicamentos en Panamá mediante soluciones tecnológicas que garantizan
            calidad y trazabilidad. Apoya a clínicas, hospitales y farmacias con una gestión eficiente del inventario.
            Su compromiso es brindar un servicio profesional enfocado en la salud pública.</p>
        </div>

        <!-- 2. Navegador -->
        <div class="footer-column">
          <h3>Navegador</h3>
          <ul>
            <li><a href="home.html">Inicio</a></li>
            <li><a href="products.html">Productos</a></li>
            <li><a href="contactus.html">Contáctanos</a></li>
          </ul>
        </div>

        <!-- 3. Redes Sociales -->
        <div class="footer-column">
          <h3>Nuestras redes sociales</h3>
          <div class="social-icons">
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="https://www.instagram.com/pharma.pty/"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-youtube"></i></a>
          </div>
        </div>

        <!-- 4. Trabaja con nosotros -->
        <div class="footer-column">
          <h3>Trabaja con nosotros</h3>
          <form class="subscribe-form">
            <input type="email" placeholder="Tu correo" required />
            <button type="submit">Enviar</button>
          </form>
        </div>
      </div>

      <!-- 5. Derechos reservados -->
      <div class="footer-bottom">
        <p>&copy; 2025 PharmaPTY. Todos los derechos reservados.</p>
      </div>
    </footer>

</body>

</html>