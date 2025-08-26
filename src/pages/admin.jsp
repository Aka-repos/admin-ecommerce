<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// Verificar que el usuario esté logueado y sea admin
String rol = (String) session.getAttribute("rol");
String usuario = (String) session.getAttribute("usuario");
Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");

if (loggedIn == null || !loggedIn || rol == null || !rol.equals("admin")) {
    response.sendRedirect("home.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaPTY | Panel Administrador</title>
    <link rel="icon" href="img/coazon.png" />
    <link rel="stylesheet" href="home.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .admin-panel {
            max-width: 1200px;
            margin: 50px auto;
            padding: 20px;
        }
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        .admin-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .admin-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .admin-card:hover {
            transform: translateY(-5px);
        }
        .admin-card h3 {
            color: #333;
            margin-bottom: 15px;
        }
        .admin-card .icon {
            font-size: 2em;
            color: #667eea;
            margin-bottom: 10px;
        }
        .logout-btn {
            background: #dc3545;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-top: 20px;
        }
        .logout-btn:hover {
            background: #c82333;
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
            </div>
            <div class="user-cart">
                <span style=" margin-right: 15px;">
                    <i class="fas fa-user-shield"></i> Administrador: <%= usuario %>
                </span>
                <a href="logout.jsp" class="login-btn">
                    <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                </a>
            </div>
        </div>
        <nav class="main-nav">
            <a href="admin.jsp" class="active">Panel Admin</a>
            <a href="home.jsp">Ir al Sitio</a>
        </nav>
    </header>

    <main class="admin-panel">
        <div class="welcome-section">
            <h1><i class="fas fa-tachometer-alt"></i> Panel de Administrador</h1>
            <p>Bienvenido <%= usuario %>, gestiona tu farmacia desde aquí</p>
        </div>

        <div class="admin-cards">
            <div class="admin-card">
                <div class="icon"><i class="fas fa-users"></i></div>
                <h3>Gestión de Usuarios</h3>
                <p>Administra usuarios, clientes y permisos del sistema.</p>
                <a href="gestionUsuarios.jsp" class="news-btn">Gestionar Usuarios</a>
            </div>

            <div class="admin-card">
                <div class="icon"><i class="fas fa-pills"></i></div>
                <h3>Inventario de Medicamentos</h3>
                <p>Controla el stock, precios y disponibilidad de productos.</p>
                <a href="inventario.jsp" class="news-btn">Ver Inventario</a>
            </div>

            <div class="admin-card">
                <div class="icon"><i class="fas fa-shopping-cart"></i></div>
                <h3>Pedidos y Ventas</h3>
                <p>Revisa pedidos, ventas y estadísticas del negocio.</p>
                <a href="pedidos.jsp" class="news-btn">Ver Pedidos</a>
            </div>

            <div class="admin-card">
                <div class="icon"><i class="fas fa-chart-bar"></i></div>
                <h3>Reportes</h3>
                <p>Genera reportes de ventas, inventario y usuarios.</p>
                <a href="reportes.jsp" class="news-btn">Ver Reportes</a>
            </div>

            <div class="admin-card">
                <div class="icon"><i class="fas fa-cog"></i></div>
                <h3>Configuración</h3>
                <p>Ajusta configuraciones del sistema y parámetros.</p>
                <a href="configuracion.jsp" class="news-btn">Configurar</a>
            </div>

            <div class="admin-card">
                <div class="icon"><i class="fas fa-bell"></i></div>
                <h3>Notificaciones</h3>
                <p>Gestiona alertas, stock bajo y notificaciones importantes.</p>
                <a href="notificaciones.jsp" class="news-btn">Ver Alertas</a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2025 PharmaPTY. Panel de Administración.</p>
        </div>
    </footer>
</body>
</html>