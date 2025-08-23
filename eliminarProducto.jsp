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

// Obtener ID del producto a eliminar
String productIdParam = request.getParameter("id");
int productId = 0;

try {
    productId = Integer.parseInt(productIdParam);
} catch (NumberFormatException e) {
%>
    <script>
        alert('ID de producto inválido');
        window.location.href = 'inventario.jsp';
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
    
    // Primero verificar si el producto existe y obtener su información
    pstCheck = con.prepareStatement("SELECT nombre, categoria, stock FROM productos WHERE id = ?");
    pstCheck.setInt(1, productId);
    rs = pstCheck.executeQuery();
    
    if (!rs.next()) {
%>
        <script>
            alert('Producto no encontrado');
            window.location.href = 'inventario.jsp';
        </script>
<%
        return;
    }
    
    String nombreProducto = rs.getString("nombre");
    String categoriaProducto = rs.getString("categoria");
    int stockProducto = rs.getInt("stock");
    
    rs.close();
    pstCheck.close();
    
    // Verificar si hay ventas asociadas al producto
    pstCheck = con.prepareStatement("SELECT COUNT(*) as ventas_count FROM ventas WHERE producto LIKE ?");
    pstCheck.setString(1, "%" + nombreProducto + "%");
    rs = pstCheck.executeQuery();
    
    int ventasAsociadas = 0;
    if (rs.next()) {
        ventasAsociadas = rs.getInt("ventas_count");
    }
    
    rs.close();
    pstCheck.close();
    
    // Si hay ventas asociadas, advertir al usuario
    if (ventasAsociadas > 0) {
%>
        <script>
            var confirmar = confirm('Este producto tiene ' + <%= ventasAsociadas %> + ' ventas asociadas en el historial.\n\n¿Deseas continuar con la eliminación?\n\nNOTA: Esto eliminará el producto pero mantendrá el historial de ventas.');
            if (!confirmar) {
                window.location.href = 'inventario.jsp';
            } else {
                var confirmarFinal = confirm('¿Estás COMPLETAMENTE SEGURO de eliminar el producto "' + '<%= nombreProducto %>' + '"?\n\nEsta acción NO se puede deshacer.');
                if (!confirmarFinal) {
                    window.location.href = 'inventario.jsp';
                }
            }
        </script>
<%
    }
    
    // Si hay stock disponible, advertir sobre pérdida de inventario
    if (stockProducto > 0) {
%>
        <script>
            var stockConfirm = confirm('ADVERTENCIA: Este producto tiene ' + <%= stockProducto %> + ' unidades en stock.\n\nEliminar el producto resultará en una pérdida de inventario valorado en el sistema.\n\n¿Deseas continuar?');
            if (!stockConfirm) {
                window.location.href = 'inventario.jsp';
            }
        </script>
<%
    }
    
    // Proceder con la eliminación
    pstDelete = con.prepareStatement("DELETE FROM productos WHERE id = ?");
    pstDelete.setInt(1, productId);
    
    int resultado = pstDelete.executeUpdate();
    
    if (resultado > 0) {
%>
        <script>
            alert('Producto "' + '<%= nombreProducto %>' + '" eliminado exitosamente');
            window.location.href = 'inventario.jsp';
        </script>
<%
    } else {
%>
        <script>
            alert('Error al eliminar el producto');
            window.location.href = 'inventario.jsp';
        </script>
<%
    }
    
} catch (SQLException e) {
    // Error de integridad referencial u otro error de BD
    String errorMsg = e.getMessage();
    if (errorMsg.contains("foreign key constraint")) {
%>
        <script>
            alert('No se puede eliminar el producto porque tiene registros relacionados en el sistema.\n\nSugerencia: Cambia el estado del producto a "Inactivo" en lugar de eliminarlo.');
            window.location.href = 'inventario.jsp';
        </script>
<%
    } else {
%>
        <script>
            alert('Error de base de datos: <%= errorMsg.replace("'", "\\'") %>');
            window.location.href = 'inventario.jsp';
        </script>
<%
    }
} catch (Exception e) {
%>
    <script>
        alert('Error inesperado: <%= e.getMessage().replace("'", "\\'") %>');
        window.location.href = 'inventario.jsp';
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
    <title>PharmaPTY | Eliminando Producto</title>
    <link rel="icon" href="img/coazon.png" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 100px auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        .loading-icon {
            font-size: 3em;
            color: #667eea;
            margin-bottom: 20px;
            animation: spin 2s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .message {
            color: #333;
            margin-bottom: 30px;
        }
        .back-link {
            color: #667eea;
            text-decoration: none;
            padding: 10px 20px;
            border: 2px solid #667eea;
            border-radius: 5px;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .back-link:hover {
            background-color: #667eea;
            color: white;
        }
        .warning {
            background: #fff3cd;
            color: #856404;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #ffc107;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="loading-icon">
            <i class="fas fa-spinner"></i>
        </div>
        
        <div class="message">
            <h2>Procesando eliminación del producto...</h2>
            <p>Por favor espera mientras se procesa la solicitud.</p>
        </div>
        
        <div class="warning">
            <strong>Nota:</strong> Si el producto tiene relaciones con otros registros del sistema, 
            se recomienda marcarlo como "Inactivo" en lugar de eliminarlo.
        </div>
        
        <div>
            <a href="inventario.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> Volver al Inventario
            </a>
        </div>
    </div>
    
    <!-- Font Awesome para los iconos -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    
    <script>
        // Redirigir automáticamente después de 5 segundos si no se ha redirigido ya
        setTimeout(function() {
            if (window.location.href.includes('eliminarProducto.jsp')) {
                window.location.href = 'inventario.jsp';
            }
        }, 5000);
        
        // Mostrar mensaje de carga
        let dots = 0;
        setInterval(function() {
            dots = (dots + 1) % 4;
            const loadingText = 'Procesando eliminación del producto' + '.'.repeat(dots);
            const messageElement = document.querySelector('.message h2');
            if (messageElement) {
                messageElement.textContent = loadingText;
            }
        }, 500);
    </script>
</body>
</html>