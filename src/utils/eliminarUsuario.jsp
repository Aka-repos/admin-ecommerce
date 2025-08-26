<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// Verificar que el usuario esté logueado y sea admin
String rol = (String) session.getAttribute("rol");
String usuarioActual = (String) session.getAttribute("usuario");
Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");

if (loggedIn == null || !loggedIn || rol == null || !rol.equals("admin")) {
    response.sendRedirect("home.jsp");
    return;
}

// Obtener ID del usuario a eliminar
String userIdParam = request.getParameter("id");
int userId = 0;

try {
    userId = Integer.parseInt(userIdParam);
} catch (NumberFormatException e) {
%>
    <script>
        alert('ID de usuario inválido');
        window.location.href = 'gestionUsuarios.jsp';
    </script>
<%
    return;
}

// Verificar que no se esté intentando eliminar a sí mismo
Integer currentUserId = (Integer) session.getAttribute("userId");
if (currentUserId != null && currentUserId == userId) {
%>
    <script>
        alert('No puedes eliminar tu propia cuenta');
        window.location.href = 'gestionUsuarios.jsp';
    </script>
<%
    return;
}

Connection con = null;
PreparedStatement pstCheck = null;
PreparedStatement pstDelete = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
    
    // Primero verificar si el usuario existe y obtener su información
    pstCheck = con.prepareStatement("SELECT nombre_usuario, rol FROM usuarios WHERE id = ?");
    pstCheck.setInt(1, userId);
    rs = pstCheck.executeQuery();
    
    if (!rs.next()) {
%>
        <script>
            alert('Usuario no encontrado');
            window.location.href = 'gestionUsuarios.jsp';
        </script>
<%
        return;
    }
    
    String nombreUsuarioEliminar = rs.getString("nombre_usuario");
    String rolUsuarioEliminar = rs.getString("rol");
    
    // Verificar si hay ventas asociadas al usuario
    rs.close();
    pstCheck.close();
    
    pstCheck = con.prepareStatement("SELECT COUNT(*) as ventas_count FROM ventas WHERE cliente_id = ?");
    pstCheck.setInt(1, userId);
    rs = pstCheck.executeQuery();
    
    int ventasAsociadas = 0;
    if (rs.next()) {
        ventasAsociadas = rs.getInt("ventas_count");
    }
    
    rs.close();
    pstCheck.close();
    
    // Si hay ventas asociadas, solo marcar como inactivo o preguntar qué hacer
    if (ventasAsociadas > 0) {
%>
        <script>
            var confirmar = confirm('Este usuario tiene ' + <%= ventasAsociadas %> + ' ventas asociadas.\n\n¿Deseas continuar con la eliminación?\n\nNOTA: Esto eliminará permanentemente el usuario pero mantendrá las ventas.');
            if (!confirmar) {
                window.location.href = 'gestionUsuarios.jsp';
            } else {
                // Continuar con la eliminación
                var confirmarFinal = confirm('¿Estás completamente seguro de eliminar al usuario "' + '<%= nombreUsuarioEliminar %>' + '"?\n\nEsta acción NO se puede deshacer.');
                if (!confirmarFinal) {
                    window.location.href = 'gestionUsuarios.jsp';
                }
            }
        </script>
<%
    }
    
    // Proceder con la eliminación
    pstDelete = con.prepareStatement("DELETE FROM usuarios WHERE id = ?");
    pstDelete.setInt(1, userId);
    
    int resultado = pstDelete.executeUpdate();
    
    if (resultado > 0) {
%>
        <script>
            alert('Usuario "<%= nombreUsuarioEliminar %>" eliminado exitosamente');
            window.location.href = 'gestionUsuarios.jsp';
        </script>
<%
    } else {
%>
        <script>
            alert('Error al eliminar el usuario');
            window.location.href = 'gestionUsuarios.jsp';
        </script>
<%
    }
    
} catch (SQLException e) {
    // Error de integridad referencial u otro error de BD
    String errorMsg = e.getMessage();
    if (errorMsg.contains("foreign key constraint")) {
%>
        <script>
            alert('No se puede eliminar el usuario porque tiene registros relacionados en el sistema');
            window.location.href = 'gestionUsuarios.jsp';
        </script>
<%
    } else {
%>
        <script>
            alert('Error de base de datos: <%= errorMsg.replace("'", "\\'") %>');
            window.location.href = 'gestionUsuarios.jsp';
        </script>
<%
    }
} catch (Exception e) {
%>
    <script>
        alert('Error inesperado: <%= e.getMessage().replace("'", "\\'") %>');
        window.location.href = 'gestionUsuarios.jsp';
    </script>
<%
} finally {
    // Cerrar conexiones
    try {
        if (rs != null) rs.close();
        if (pstCheck != null) pstCheck.close();
        if (pstDelete != null) pstDelete.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaPTY | Eliminando Usuario</title>
    <link rel="icon" href="img/coazon.png" />
</head>
<body>
    <div style="text-align: center; margin-top: 50px; font-family: Arial, sans-serif;">
        <h2>Procesando eliminación...</h2>
        <p>Por favor espera mientras se procesa la solicitud.</p>
        <div style="margin-top: 20px;">
            <a href="gestionUsuarios.jsp" style="color: #007bff; text-decoration: none;">
                Volver a Gestión de Usuarios
            </a>
        </div>
    </div>
    
    <script>
        // Redirigir automáticamente después de 3 segundos si no se ha redirigido ya
        setTimeout(function() {
            if (window.location.href.includes('eliminarUsuario.jsp')) {
                window.location.href = 'gestionUsuarios.jsp';
            }
        }, 3000);
    </script>
</body>
</html>