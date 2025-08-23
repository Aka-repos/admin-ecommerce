<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// Verificar que el usuario esté logueado y sea admin
String rol = (String) session.getAttribute("rol");
String usuario = (String) session.getAttribute("usuario");
Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");

if (loggedIn == null || !loggedIn || rol == null || !rol.equals("admin")) {
    response.sendRedirect("home.jsp");
    return;
}

// Obtener ID del usuario a editar
String userIdParam = request.getParameter("id");
int userId = 0;
try {
    userId = Integer.parseInt(userIdParam);
} catch (NumberFormatException e) {
    response.sendRedirect("gestionUsuarios.jsp");
    return;
}

// Procesar actualización si se envió el formulario
String action = request.getParameter("action");
if ("update".equals(action)) {
    String nombreUsuario = request.getParameter("nombre_usuario");
    String email = request.getParameter("email");
    String nuevaPassword = request.getParameter("nueva_password");
    String rolUsuario = request.getParameter("rol_usuario");
    
    Connection con = null;
    PreparedStatement pst = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
        
        String sql;
        if (nuevaPassword != null && !nuevaPassword.trim().isEmpty()) {
            // Actualizar con nueva contraseña
            sql = "UPDATE usuarios SET nombre_usuario=?, email=?, contraseña=?, rol=? WHERE id=?";
            pst = con.prepareStatement(sql);
            pst.setString(1, nombreUsuario);
            pst.setString(2, email);
            pst.setString(3, nuevaPassword);
            pst.setString(4, rolUsuario);
            pst.setInt(5, userId);
        } else {
            // Actualizar sin cambiar contraseña
            sql = "UPDATE usuarios SET nombre_usuario=?, email=?, rol=? WHERE id=?";
            pst = con.prepareStatement(sql);
            pst.setString(1, nombreUsuario);
            pst.setString(2, email);
            pst.setString(3, rolUsuario);
            pst.setInt(4, userId);
        }
        
        int result = pst.executeUpdate();
        
        if (result > 0) {
%>
            <script>
                alert('Usuario actualizado exitosamente');
                window.location.href = 'gestionUsuarios.jsp';
            </script>
<%
        } else {
%>
            <script>
                alert('Error al actualizar el usuario');
            </script>
<%
        }
        
    } catch (Exception e) {
%>
        <script>
            alert('Error: <%= e.getMessage() %>');
        </script>
<%
    } finally {
        try {
            if (pst != null) pst.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

// Obtener datos del usuario
Connection con = null;
PreparedStatement pst = null;
ResultSet rs = null;

String nombreUsuarioActual = "";
String emailActual = "";
String rolActual = "";
String fechaRegistro = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
    
    pst = con.prepareStatement("SELECT * FROM usuarios WHERE id = ?");
    pst.setInt(1, userId);
    rs = pst.executeQuery();
    
    if (rs.next()) {
        nombreUsuarioActual = rs.getString("nombre_usuario");
        emailActual = rs.getString("email");
        rolActual = rs.getString("rol");
        fechaRegistro = rs.getString("fecha_registro");
    } else {
        response.sendRedirect("gestionUsuarios.jsp");
        return;
    }
    
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("gestionUsuarios.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaPTY | Editar Usuario</title>
    <link rel="icon" href="img/coazon.png" />
    <link rel="stylesheet" href="home.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .admin-panel {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        .header-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            box-sizing: border-box;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 1em;
            text-align: center;
        }
        .btn-primary {
            background-color: #667eea;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .user-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .password-note {
            font-size: 0.9em;
            color: #666;
            font-style: italic;
        }
        .required {
            color: #dc3545;
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
                <span style="margin-right: 15px;">
                    <i class="fas fa-user-shield"></i> Administrador: <%= usuario %>
                </span>
                <a href="logout.jsp" class="login-btn">
                    <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                </a>
            </div>
        </div>
        <nav class="main-nav">
            <a href="admin.jsp">Panel Admin</a>
            <a href="gestionUsuarios.jsp">Gestión de Usuarios</a>
            <a href="reportes.jsp">Reportes</a>
            <a href="home.jsp">Ir al Sitio</a>
        </nav>
    </header>

    <main class="admin-panel">
        <div class="header-section">
            <h1><i class="fas fa-user-edit"></i> Editar Usuario</h1>
            <p>Modifica la información del usuario seleccionado</p>
        </div>

        <div class="form-container">
            <div class="user-info">
                <h3><i class="fas fa-info-circle"></i> Información Actual</h3>
                <p><strong>ID:</strong> <%= userId %></p>
                <p><strong>Fecha de Registro:</strong> <%= fechaRegistro %></p>
            </div>

            <form method="post" action="editarUsuario.jsp" onsubmit="return validarFormulario()">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= userId %>">

                <div class="form-group">
                    <label for="nombre_usuario">
                        <i class="fas fa-user"></i> Nombre de Usuario <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="nombre_usuario" 
                           name="nombre_usuario" 
                           value="<%= nombreUsuarioActual %>" 
                           required 
                           minlength="3"
                           maxlength="50">
                </div>

                <div class="form-group">
                    <label for="email">
                        <i class="fas fa-envelope"></i> Correo Electrónico <span class="required">*</span>
                    </label>
                    <input type="email" 
                           id="email" 
                           name="email" 
                           value="<%= emailActual %>" 
                           required>
                </div>

                <div class="form-group">
                    <label for="nueva_password">
                        <i class="fas fa-lock"></i> Nueva Contraseña
                    </label>
                    <input type="password" 
                           id="nueva_password" 
                           name="nueva_password" 
                           minlength="6"
                           placeholder="Dejar en blanco para mantener la actual">
                    <div class="password-note">
                        * Deja este campo vacío si no deseas cambiar la contraseña
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmar_password">
                        <i class="fas fa-lock"></i> Confirmar Nueva Contraseña
                    </label>
                    <input type="password" 
                           id="confirmar_password" 
                           name="confirmar_password" 
                           placeholder="Confirmar nueva contraseña">
                </div>

                <div class="form-group">
                    <label for="rol_usuario">
                        <i class="fas fa-user-tag"></i> Rol del Usuario <span class="required">*</span>
                    </label>
                    <select id="rol_usuario" name="rol_usuario" required>
                        <option value="cliente" <%= "cliente".equals(rolActual) ? "selected" : "" %>>Cliente</option>
                        <option value="admin" <%= "admin".equals(rolActual) ? "selected" : "" %>>Administrador</option>
                    </select>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Guardar Cambios
                    </button>
                    
                    <a href="gestionUsuarios.jsp" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancelar
                    </a>
                </div>
            </form>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2025 PharmaPTY. Panel de Administración.</p>
        </div>
    </footer>

    <script>
        function validarFormulario() {
            const nuevaPassword = document.getElementById('nueva_password').value;
            const confirmarPassword = document.getElementById('confirmar_password').value;
            const nombreUsuario = document.getElementById('nombre_usuario').value.trim();
            const email = document.getElementById('email').value.trim();

            // Validar campos requeridos
            if (!nombreUsuario) {
                alert('El nombre de usuario es requerido');
                return false;
            }

            if (!email) {
                alert('El correo electrónico es requerido');
                return false;
            }

            // Validar formato de email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('Por favor ingresa un correo electrónico válido');
                return false;
            }

            // Validar contraseñas si se está cambiando
            if (nuevaPassword || confirmarPassword) {
                if (nuevaPassword !== confirmarPassword) {
                    alert('Las contraseñas no coinciden');
                    return false;
                }
                
                if (nuevaPassword.length < 6) {
                    alert('La nueva contraseña debe tener al menos 6 caracteres');
                    return false;
                }
            }

            return true;
        }

        // Confirmación antes de enviar
        document.querySelector('form').addEventListener('submit', function(e) {
            if (!confirm('¿Estás seguro de que deseas actualizar este usuario?')) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>

<%
try {
    if (rs != null) rs.close();
    if (pst != null) pst.close();
    if (con != null) con.close();
} catch (SQLException e) {
    e.printStackTrace();
}
%>