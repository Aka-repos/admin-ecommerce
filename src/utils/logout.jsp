<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// Invalidar la sesión actual
session.invalidate();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaPTY | Sesión Cerrada</title>
    <link rel="icon" href="img/coazon.png" />
</head>
<body>
    <script>
        alert('Sesión cerrada exitosamente');
        // Redirigir a la página principal después de 2 segundos
        setTimeout(function() {
            window.location.href = 'home.jsp';
        }, 2000);
    </script>
    
    <div style="text-align: center; margin-top: 50px; font-family: Arial, sans-serif;">
        <h2>Sesión cerrada exitosamente</h2>
        <p>Serás redirigido a la página principal...</p>
        <a href="home.jsp" style="color: #007bff; text-decoration: none;">
            Si no eres redirigido automáticamente, haz clic aquí
        </a>
    </div>
</body>
</html>