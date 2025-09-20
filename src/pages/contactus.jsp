<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8" />
  <title>PharmaPTY | Contáctanos</title>
  <link rel="icon" href="img/coazon.png" />
  <link rel="stylesheet" href="../styles/contactus.css" />
  <link rel="stylesheet" href="../styles/home.css" />
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
<!--INCLUIR HEADAER-->
  <%@ include file="/src/utils/header.jsp" %>

  <!-- INCLUIR MODALES -->
  <%@ include file="/src/utils/modal.jsp" %>
  
  <main>
    <section class="team-section">
      <h2 class="section-title">Conoce a nuestro equipo</h2>
      <div class="team-container">

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