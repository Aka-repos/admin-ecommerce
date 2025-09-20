<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8" />
  <title>PharmaPTY | Contáctanos</title>
  <link rel="icon" href="img/coazon.png" />
  <link rel="stylesheet" href="contactus.css" />
  <link rel="stylesheet" href="home.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    /* Pequeño ajuste para las imágenes de bandera */
    .flag-icon {
      width: 22px;
      height: 15px;
      vertical-align: middle;
      margin-left: 6px;
      border-radius: 2px;
      object-fit: cover;
      display: inline-block;
    }
  </style>
</head>

<body>
  <header class="sticky-header">
    <div class="top-header">
      <div class="logo">
        <img src="img/coazon.png" alt="Logo" />
        <h1 class="typing-effect">
          <span class="pharma">PHARMA</span><span class="pty">PTY</span>
        </h1>
        <a href="#" class="search-btn"><i class="fas fa-search"></i></a>
      </div>
      <div class="social-icons">
        <a href="#" class="icon twitter"><i class="fab fa-twitter"></i></a>
        <a href="https://www.instagram.com/pharma.pty/" class="icon instagram"><i class="fab fa-instagram"></i></a>
        <a href="#" class="icon youtube"><i class="fab fa-youtube"></i></a>
        <a href="#" class="icon facebook"><i class="fab fa-facebook-f"></i></a>
      </div>
      <div class="user-cart">
        <a href="#" id="btnOpenLogin" class="login-btn"><i class="fas fa-user"></i> Iniciar sesión</a>
        <a href="#" class="cart-btn"><i class="fas fa-shopping-cart"></i></a>
      </div>
    </div>

    <nav class="main-nav">
      <a href="home.jsp">Inicio</a>
      <a href="products.jsp">Productos</a>
      <a href="contactus.jsp" class="active">Contáctanos</a>
    </nav>
  </header>
  
  <!-- INCLUIR MODALES -->
  <%@ include file="modal.jsp" %>
  
  <main>
    <section class="team-section">
      <h2 class="section-title">Conoce a nuestro equipo</h2>
      <div class="team-container">

        <!-- Cristina Jordán -->
        <div class="team-card" tabindex="0">
          <div class="card-inner">
            <div class="card-front">
              <div class="team-image">
                <img src="img/imgcontact/integrante1.jpg" alt="Cristina Jordán" />
              </div>
              <div class="team-info">
                <h3>
                  Cristina Jordán
                  <img class="flag-icon" src="https://flagcdn.com/w20/pa.png" alt="Panamá" title="Panamá" />
                </h3>
                <p>Encargada de la interfaz web responsiva para este proyecto.</p>
              </div>
            </div>
            <div class="card-back">
              <p><strong>Cédula:</strong> 8-1032-41<br>
                <strong>Carrera:</strong> Ing. de Software<br>
                <strong>Correo:</strong> cristina.jordan@utp.ac.pa
              </p>
            </div>
          </div>
        </div>

        <!-- Andrés Vega -->
        <div class="team-card" tabindex="0">
          <div class="card-inner">
            <div class="card-front">
              <div class="team-image">
                <img src="img/imgcontact/integrante2.jpg" alt="Andrés Vega" />
              </div>
              <div class="team-info">
                <h3>
                  Andrés Vega
                  <img class="flag-icon" src="https://flagcdn.com/w20/pa.png" alt="Panamá" title="Panamá" />
                </h3>
                <p>Encargado del backend de esta página.</p>
              </div>
            </div>
            <div class="card-back">
              <p><strong>Cédula:</strong> 8-1003-1210<br>
                <strong>Carrera:</strong> Ing. de Software<br>
                <strong>Correo:</strong> andres.vega@utp.ac.pa
              </p>
            </div>
          </div>
        </div>

        <!-- Alejandra Gómez -->
        <div class="team-card" tabindex="0">
          <div class="card-inner">
            <div class="card-front">
              <div class="team-image">
                <img src="img/imgcontact/integrante3.jpg" alt="Alejandra Gómez" />
              </div>
              <div class="team-info">
                <h3>
                  Alejandra Gómez
                  <img class="flag-icon" src="https://flagcdn.com/w20/co.png" alt="Colombia" title="Colombia" />
                  <img class="flag-icon" src="https://flagcdn.com/w20/pa.png" alt="Panamá" title="Panamá" />
                </h3>
                <p>Encargada de los requerimientos para la página web.</p>
              </div>
            </div>
            <div class="card-back">
              <p><strong>Cédula:</strong> 20-14-7146<br>
                <strong>Carrera:</strong> Ing. de Software<br>
                <strong>Correo:</strong> alejandra.gomez@utp.ac.pa
              </p>
            </div>
          </div>
        </div>

        <!-- Raúl Medina -->
        <div class="team-card" tabindex="0">
          <div class="card-inner">
            <div class="card-front">
              <div class="team-image">
                <img src="img/imgcontact/integrante4.jpg" alt="Raúl Medina" />
              </div>
              <div class="team-info">
                <h3>
                  Raúl Medina
                  <img class="flag-icon" src="https://flagcdn.com/w20/pa.png" alt="Panamá" title="Panamá" />
                </h3>
                <p>Encargado del frontend de la página.</p>
              </div>
            </div>
            <div class="card-back">
              <p><strong>Cédula:</strong> 8-1021-948<br>
                <strong>Carrera:</strong> Ing. de Software<br>
                <strong>Correo:</strong> raul.medina@utp.ac.pa
              </p>
            </div>
          </div>
        </div>

        <!-- William Rush -->
        <div class="team-card" tabindex="0">
          <div class="card-inner">
            <div class="card-front">
              <div class="team-image">
                <img src="img/imgcontact/integrante5.jpg" alt="William Rush" />
              </div>
              <div class="team-info">
                <h3>
                  William Rush
                  <img class="flag-icon" src="https://flagcdn.com/w20/pa.png" alt="Panamá" title="Panamá" />
                </h3>
                <p>Encargado de los requerimientos backend de esta página web.</p>
              </div>
            </div>
            <div class="card-back">
              <p><strong>Cédula:</strong> 8-1017-1144<br>
                <strong>Carrera:</strong> Ing. de Software<br>
                <strong>Correo:</strong> william.rush@utp.ac.pa
              </p>
            </div>
          </div>
        </div>

      </div>
    </section>
  </main>
<%@ include file="../utils/footer.jsp" %>

  <script>
    // Flip al hacer clic
    document.querySelectorAll(".team-card").forEach(card => {
      card.addEventListener("click", () => {
        card.classList.toggle("flipped");
      });
    });

    // Efecto header al hacer scroll
    window.addEventListener("scroll", () => {
      const header = document.querySelector(".sticky-header");
      header.classList.toggle("scrolled", window.scrollY > 50);
    });
  </script>
</body>

</html>