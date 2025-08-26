<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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
    <title>PharmaPTY | Gestión de Usuarios</title>
    <link rel="icon" href="img/coazon.png" />
    <link rel="stylesheet" href="home.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .admin-panel {
            max-width: 1400px;
            margin: 50px auto;
            padding: 20px;
        }
        .header-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .users-table {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .role-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        .role-admin {
            background-color: #dc3545;
            color: white;
        }
        .role-cliente {
            background-color: #28a745;
            color: white;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .btn-action {
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.8em;
            color: white;
        }
        .btn-edit {
            background-color: #007bff;
        }
        .btn-delete {
            background-color: #dc3545;
        }
        .btn-view {
            background-color: #6c757d;
        }
        .btn-add {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
        }
        .search-box {
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 300px;
        }
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
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
            <a href="admin.jsp">Panel Admin</a>
            <a href="gestionUsuarios.jsp" class="active">Gestión de Usuarios</a>
            <a href="reportes.jsp">Reportes</a>
            <a href="home.jsp">Ir al Sitio</a>
        </nav>
    </header>

    <main class="admin-panel">
        <div class="header-section">
            <div>
                <h1><i class="fas fa-users"></i> Gestión de Usuarios</h1>
                <p>Administra todos los usuarios del sistema</p>
            </div>
            <div>
                <a href="agregarUsuario.jsp" class="btn-add">
                    <i class="fas fa-plus"></i> Agregar Usuario
                </a>
            </div>
        </div>

        <%
        // Obtener estadísticas de usuarios
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        int totalUsuarios = 0;
        int totalAdmins = 0;
        int totalClientes = 0;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
            
            // Contar total de usuarios
            pst = con.prepareStatement("SELECT COUNT(*) as total FROM usuarios");
            rs = pst.executeQuery();
            if (rs.next()) totalUsuarios = rs.getInt("total");
            rs.close();
            pst.close();
            
            // Contar admins
            pst = con.prepareStatement("SELECT COUNT(*) as total FROM usuarios WHERE rol = 'admin'");
            rs = pst.executeQuery();
            if (rs.next()) totalAdmins = rs.getInt("total");
            rs.close();
            pst.close();
            
            // Contar clientes
            pst = con.prepareStatement("SELECT COUNT(*) as total FROM usuarios WHERE rol = 'cliente'");
            rs = pst.executeQuery();
            if (rs.next()) totalClientes = rs.getInt("total");
            rs.close();
            pst.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>

        <div class="stats-cards">
            <div class="stat-card">
                <div class="stat-number"><%= totalUsuarios %></div>
                <div>Total Usuarios</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalAdmins %></div>
                <div>Administradores</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalClientes %></div>
                <div>Clientes</div>
            </div>
        </div>

        <div class="users-table">
            <h3><i class="fas fa-list"></i> Lista de Usuarios</h3>
            
            <input type="text" class="search-box" placeholder="Buscar usuario..." 
                   onkeyup="filtrarUsuarios(this.value)">

            <table id="usersTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Usuario</th>
                        <th>Email</th>
                        <th>Rol</th>
                        <th>Fecha Registro</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    try {
                        if (con != null) {
                            pst = con.prepareStatement("SELECT * FROM usuarios ORDER BY fecha_registro DESC");
                            rs = pst.executeQuery();
                            
                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String nombreUsuario = rs.getString("nombre_usuario");
                                String email = rs.getString("email");
                                String rolUsuario = rs.getString("rol");
                                String fechaRegistro = rs.getString("fecha_registro");
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= nombreUsuario %></td>
                        <td><%= email %></td>
                        <td>
                            <span class="role-badge role-<%= rolUsuario %>">
                                <%= rolUsuario.toUpperCase() %>
                            </span>
                        </td>
                        <td><%= fechaRegistro %></td>
                        <td>
                            <div class="action-buttons">
                                <a href="verUsuario.jsp?id=<%= id %>" class="btn-action btn-view">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="editarUsuario.jsp?id=<%= id %>" class="btn-action btn-edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="eliminarUsuario.jsp?id=<%= id %>" class="btn-action btn-delete" 
                                   onclick="return confirm('¿Estás seguro de eliminar este usuario?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6'>Error al cargar usuarios: " + e.getMessage() + "</td></tr>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (pst != null) pst.close();
                            if (con != null) con.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    %>
                </tbody>
            </table>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2025 PharmaPTY. Panel de Administración.</p>
        </div>
    </footer>

    <script>
        function filtrarUsuarios(filtro) {
            const tabla = document.getElementById('usersTable');
            const filas = tabla.getElementsByTagName('tr');
            
            for (let i = 1; i < filas.length; i++) {
                const fila = filas[i];
                const textoFila = fila.textContent.toLowerCase();
                
                if (textoFila.includes(filtro.toLowerCase())) {
                    fila.style.display = '';
                } else {
                    fila.style.display = 'none';
                }
            }
        }
    </script>
</body>
</html>