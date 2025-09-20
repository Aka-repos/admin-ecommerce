<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <title>PharmaPTY | Servicios Clínicos</title>
  <link rel="icon" href="../img/coazon.png" />
  <link rel="stylesheet" href="../styles/home.css" />
  <link rel="stylesheet" href="../styles/products.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    /* Estilos básicos (si aún no tienes services.css) */
    .services-header { text-align:center; padding: 20px 12px; }
    .services-header h1 { margin: 0 0 8px; }
    .filters-section { display:grid; gap:12px; grid-template-columns:1fr 1fr; max-width:900px; margin:0 auto 18px; padding:0 12px;}
    .filter-group label { font-weight:600; display:block; margin-bottom:6px; }
    .filter-group input, .filter-group select { width:100%; padding:10px; border:1px solid #e3e3e3; border-radius:8px; }
    .services-grid { display:grid; gap:16px; grid-template-columns: repeat(auto-fill, minmax(260px,1fr)); padding: 0 12px 32px; max-width:1200px; margin:0 auto;}
    .service-card { background:#fff; border:1px solid #f0f0f0; border-radius:14px; padding:16px; display:flex; flex-direction:column; gap:10px; box-shadow: 0 2px 8px rgba(0,0,0,.04); }
    .service-card h3 { margin:0; font-size:1.12rem; display:flex; align-items:center; gap:8px; }
    .service-meta { font-size:.92rem; color:#555; display:flex; flex-wrap:wrap; gap:10px; }
    .service-meta span { background:#f7f7f7; padding:6px 10px; border-radius:999px; }
    .service-desc { color:#444; }
    .service-cta { display:flex; gap:8px; margin-top:auto; }
    .btn { display:inline-flex; align-items:center; gap:8px; padding:10px 12px; border-radius:10px; text-decoration:none; font-weight:600; }
    .btn-primary { background:#1f8a70; color:#fff; }
    .btn-outline { border:1px solid #1f8a70; color:#1f8a70; background:#fff; }
    @media (max-width:720px){ .filters-section { grid-template-columns:1fr; } }
  </style>
</head>
<body>
  <%@ include file="../utils/header.jsp" %>
  <%@ include file="../utils/modal.jsp" %>

  <main>
    <section class="services-header">
      <h1><i class="fa-solid fa-stethoscope"></i> Servicios Clínicos</h1>
      <p>Atención médica integral en tu clínica & farmacia. Agenda tu cita y recibe resultados en línea.</p>
    </section>

    <!-- Filtros -->
    <section class="filters-section">
      <div class="filter-group">
        <label for="searchService"><i class="fas fa-search"></i> Buscar servicio</label>
        <input id="searchService" type="text" placeholder="Consulta general, laboratorio, vacunación…" onkeyup="filtrarServicios()">
      </div>
      <div class="filter-group">
        <label for="categoryService"><i class="fas fa-tags"></i> Categoría</label>
        <select id="categoryService" onchange="filtrarServicios()">
          <option value="">Todas</option>
          <option value="Consultas">Consultas</option>
          <option value="Laboratorio">Laboratorio</option>
          <option value="Vacunación">Vacunación</option>
          <option value="Enfermería">Enfermería</option>
          <option value="Telemedicina">Telemedicina</option>
          <option value="Crónicos">Crónicos</option>
          <option value="Fisioterapia">Fisioterapia</option>
          <option value="Odontología">Odontología</option>
          <option value="Psicología">Psicología</option>
          <option value="Nutrición">Nutrición</option>
          <option value="Imagenología">Imagenología</option>
          <option value="Emergencias leves">Emergencias leves</option>
        </select>
      </div>
    </section>

    <!-- Grid de Servicios -->
    <section class="services-grid" id="servicesGrid">
      <!-- Consulta General -->
      <article class="service-card" data-name="consulta general medicina familiar" data-category="Consultas">
        <h3><i class="fa-solid fa-user-doctor"></i> Consulta General</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 8:00–18:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $20</span>
          <span><i class="fa-solid fa-id-card"></i> Aseguradoras: Sí</span>
        </div>
        <p class="service-desc">Valoración integral por médico general: diagnóstico inicial, formulación y seguimiento.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=CONS-GEN">Reservar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=CONS-GEN">Detalles</a>
        </div>
      </article>

      <!-- Pediatría -->
      <article class="service-card" data-name="pediatría consulta niños" data-category="Consultas">
        <h3><i class="fa-solid fa-baby"></i> Consulta de Pediatría</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 9:00–17:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $25</span>
          <span><i class="fa-solid fa-id-card"></i> Aseguradoras: Sí</span>
        </div>
        <p class="service-desc">Controles de crecimiento, vacunación, manejo de cuadros agudos y consejería a padres.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=PEDS-CONS">Reservar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=PEDS-CONS">Detalles</a>
        </div>
      </article>

      <!-- Laboratorio: Perfil Básico -->
      <article class="service-card" data-name="laboratorio perfil básico exámenes sangre" data-category="Laboratorio">
        <h3><i class="fa-solid fa-flask-vial"></i> Laboratorio – Perfil Básico</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 7:00–16:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $18</span>
          <span><i class="fa-solid fa-droplet"></i> Ayuno 8–12 h</span>
        </div>
        <p class="service-desc">Hemograma, glicemia, lípidos, función renal/hepática. Resultados digitales.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=LAB-PERF">Agendar toma</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=LAB-PERF">Panel</a>
        </div>
      </article>

      <!-- Vacunación -->
      <article class="service-card" data-name="vacunación influenza covid hepatitis" data-category="Vacunación">
        <h3><i class="fa-solid fa-syringe"></i> Vacunación (Influenza, COVID, Hepatitis)</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 8:00–18:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $15</span>
          <span><i class="fa-solid fa-shield-heart"></i> Cadena de frío garantizada</span>
        </div>
        <p class="service-desc">Esquemas para niños y adultos. Registro y carnetización en sitio.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=VAC-GEN">Reservar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=VAC-GEN">Requisitos</a>
        </div>
      </article>

      <!-- Enfermería: Curaciones e Inyectables -->
      <article class="service-card" data-name="enfermería curaciones inyectables signos vitales" data-category="Enfermería">
        <h3><i class="fa-solid fa-user-nurse"></i> Enfermería – Curaciones & Inyectables</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–D 8:00–20:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $10</span>
          <span><i class="fa-solid fa-bandage"></i> Material estéril</span>
        </div>
        <p class="service-desc">Administración de medicamentos, curaciones, control de signos vitales.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=ENF-BASE">Agendar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=ENF-BASE">Ver más</a>
        </div>
      </article>

      <!-- Crónicos: Hipertensión/Diabetes -->
      <article class="service-card" data-name="crónicos hipertensión diabetes control seguimiento" data-category="Crónicos">
        <h3><i class="fa-solid fa-heart-pulse"></i> Control de Crónicos (HTA/DM)</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 8:00–17:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $22</span>
          <span><i class="fa-solid fa-mobile-screen"></i> Plan de seguimiento</span>
        </div>
        <p class="service-desc">Ajuste de tratamiento, metas clínicas, educación y adherencia terapéutica.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=CRON-CTRL">Reservar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=CRON-CTRL">Programa</a>
        </div>
      </article>

      <!-- Telemedicina -->
      <article class="service-card" data-name="telemedicina consulta en línea" data-category="Telemedicina">
        <h3><i class="fa-solid fa-video"></i> Telemedicina</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–D 7:00–21:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $18</span>
          <span><i class="fa-solid fa-file-prescription"></i> Receta digital</span>
        </div>
        <p class="service-desc">Atención virtual segura, seguimiento de cuadros leves y renovación de recetas.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=TEL-MED">Agendar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=TEL-MED">Cómo funciona</a>
        </div>
      </article>

      <!-- Fisioterapia -->
      <article class="service-card" data-name="fisioterapia rehabilitación dolor espalda" data-category="Fisioterapia">
        <h3><i class="fa-solid fa-person-running"></i> Fisioterapia</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 8:00–18:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $25</span>
          <span><i class="fa-solid fa-dumbbell"></i> Planes por sesiones</span>
        </div>
        <p class="service-desc">Rehabilitación músculo-esquelética, dolor lumbar, post-operatorio.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=FISIO-STD">Reservar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=FISIO-STD">Protocolos</a>
        </div>
      </article>

      <!-- Odontología -->
      <article class="service-card" data-name="odontología limpieza dental urgencias" data-category="Odontología">
        <h3><i class="fa-solid fa-tooth"></i> Odontología – Limpieza & Urgencias</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 9:00–17:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $30</span>
          <span><i class="fa-solid fa-tooth"></i> Profilaxis & resinas</span>
        </div>
        <p class="service-desc">Limpieza, resinas, extracciones simples y manejo de dolor agudo.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=ODO-BAS">Reservar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=ODO-BAS">Lista de precios</a>
        </div>
      </article>

      <!-- Psicología -->
      <article class="service-card" data-name="psicología salud mental ansiedad" data-category="Psicología">
        <h3><i class="fa-solid fa-brain"></i> Psicología</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 10:00–18:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $28</span>
          <span><i class="fa-solid fa-shield"></i> Confidencial</span>
        </div>
        <p class="service-desc">Atención individual, estrés, ansiedad y apoyo en hábitos saludables.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=PSI-GEN">Reservar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=PSI-GEN">Enfoques</a>
        </div>
      </article>

      <!-- Nutrición -->
      <article class="service-card" data-name="nutrición dietas control peso" data-category="Nutrición">
        <h3><i class="fa-solid fa-apple-whole"></i> Nutrición</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 9:00–17:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Desde $22</span>
          <span><i class="fa-solid fa-weight-scale"></i> Plan personalizado</span>
        </div>
        <p class="service-desc">Evaluación de composición corporal y plan de alimentación.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=NUTRI-BASE">Reservar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=NUTRI-BASE">Detalles</a>
        </div>
      </article>

      <!-- Imagenología básica -->
      <article class="service-card" data-name="imagenología rayos x ultrasonido" data-category="Imagenología">
        <h3><i class="fa-solid fa-x-ray"></i> Imagenología – Rx/US Básico</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–S 8:00–16:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Rx desde $20</span>
          <span><i class="fa-solid fa-file-waveform"></i> Informe digital</span>
        </div>
        <p class="service-desc">Rayos X simples y ultrasonido básico con entrega rápida de resultados.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=IMG-BAS">Agendar</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=IMG-BAS">Estudios</a>
        </div>
      </article>

      <!-- Urgencias Leves -->
      <article class="service-card" data-name="emergencias leves suturas control dolor" data-category="Emergencias leves">
        <h3><i class="fa-solid fa-kit-medical"></i> Urgencias Leves</h3>
        <div class="service-meta">
          <span><i class="fa-regular fa-clock"></i> L–D 7:00–21:00</span>
          <span><i class="fa-solid fa-dollar-sign"></i> Triages desde $12</span>
          <span><i class="fa-solid fa-truck-medical"></i> Derivación si aplica</span>
        </div>
        <p class="service-desc">Suturas simples, manejo de dolor, febrículas, esguinces menores.</p>
        <div class="service-cta">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/appointments/new?serviceId=ERG-LEV">Atender ahora</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/services/details?serviceId=ERG-LEV">Protocolos</a>
        </div>
      </article>
    </section>
  </main>

  <%@ include file="../utils/footer.jsp" %>

  <script>
    function filtrarServicios() {
      const q = (document.getElementById('searchService').value || '').toLowerCase();
      const cat = (document.getElementById('categoryService').value || '').toLowerCase();
      const cards = document.querySelectorAll('#servicesGrid .service-card');
      cards.forEach(c => {
        const name = (c.getAttribute('data-name') || '').toLowerCase();
        const category = (c.getAttribute('data-category') || '').toLowerCase();
        const matchQ = !q || name.includes(q);
        const matchC = !cat || category === cat;
        c.style.display = (matchQ && matchC) ? '' : 'none';
      });
    }
  </script>
</body>
</html>
