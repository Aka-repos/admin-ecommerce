<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DecimalFormat" %>
<%
// Verificar que el usuario esté logueado y sea admin
String rol = (String) session.getAttribute("rol");
Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");

if (loggedIn == null || !loggedIn || rol == null || !rol.equals("admin")) {
    response.sendRedirect("home.jsp");
    return;
}

// Configurar respuesta para descarga de Excel
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=\"inventario_pharmapty_" + 
    new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + ".xls\"");

Connection con = null;
PreparedStatement pst = null;
ResultSet rs = null;
DecimalFormat df = new DecimalFormat("#,##0.00");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inventario PharmaPTY</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            font-family: Arial, sans-serif;
        }
        th, td {
            border: 1px solid #black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #667eea;
            color: white;
            font-weight: bold;
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        .summary {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f8f9fa;
            border: 1px solid #ddd;
        }
        .categoria-medicamentos { background-color: #ffe6e6; }
        .categoria-vitaminas { background-color: #e6ffe6; }
        .categoria-cuidado_personal { background-color: #e6f3ff; }
        .categoria-bebes { background-color: #fff9e6; }
        .categoria-primeros_auxilios { background-color: #f0f0f0; }
        .categoria-otros { background-color: #e6f9f9; }
        .stock-bajo { background-color: #f8d7da; color: #721c24; }
        .stock-medio { background-color: #fff3cd; color: #856404; }
        .stock-alto { background-color: #d4edda; color: #155724; }
    </style>
</head>
<body>
    <div class="header">
        <h1>PharmaPTY - Inventario de Productos</h1>
        <h3>Generado el: <%= new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()) %></h3>
    </div>

    <%
    // Obtener estadísticas generales
    int totalProductos = 0;
    int productosActivos = 0;
    int stockBajo = 0;
    double valorInventario = 0;
    
    pst = con.prepareStatement("SELECT COUNT(*) as total FROM productos");
    rs = pst.executeQuery();
    if (rs.next()) totalProductos = rs.getInt("total");
    rs.close();
    pst.close();
    
    pst = con.prepareStatement("SELECT COUNT(*) as activos FROM productos WHERE estado = 'activo'");
    rs = pst.executeQuery();
    if (rs.next()) productosActivos = rs.getInt("activos");
    rs.close();
    pst.close();
    
    pst = con.prepareStatement("SELECT COUNT(*) as bajo FROM productos WHERE stock < 20 AND estado = 'activo'");
    rs = pst.executeQuery();
    if (rs.next()) stockBajo = rs.getInt("bajo");
    rs.close();
    pst.close();
    
    pst = con.prepareStatement("SELECT SUM(precio * stock) as valor FROM productos WHERE estado = 'activo'");
    rs = pst.executeQuery();
    if (rs.next()) valorInventario = rs.getDouble("valor");
    rs.close();
    pst.close();
    %>

    <div class="summary">
        <h3>Resumen del Inventario</h3>
        <p><strong>Total de Productos:</strong> <%= totalProductos %></p>
        <p><strong>Productos Activos:</strong> <%= productosActivos %></p>
        <p><strong>Productos con Stock Bajo:</strong> <%= stockBajo %></p>
        <p><strong>Valor Total del Inventario:</strong> $<%= df.format(valorInventario) %></p>
    </div>

    <h3>Detalle de Productos</h3>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>Categoría</th>
                <th>Marca</th>
                <th>Precio</th>
                <th>Stock</th>
                <th>Valor Stock</th>
                <th>Código Barras</th>
                <th>Receta</th>
                <th>Estado</th>
                <th>Fecha Creación</th>
            </tr>
        </thead>
        <tbody>
            <%
            // Consultar todos los productos
            String sql = "SELECT * FROM productos ORDER BY categoria, nombre";
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                String nombre = rs.getString("nombre");
                String descripcion = rs.getString("descripcion");
                String categoria = rs.getString("categoria");
                String marca = rs.getString("marca");
                double precio = rs.getDouble("precio");
                int stock = rs.getInt("stock");
                String codigoBarras = rs.getString("codigo_barras");
                boolean prescripcion = rs.getBoolean("prescripcion_requerida");
                String estado = rs.getString("estado");
                String fechaCreacion = rs.getString("fecha_creacion");
                
                double valorStock = precio * stock;
                String stockClass = stock < 20 ? "stock-bajo" : (stock <= 50 ? "stock-medio" : "stock-alto");
                String categoriaClass = "categoria-" + categoria;
                String categoriaDisplay = categoria.replace("_", " ");
                categoriaDisplay = categoriaDisplay.substring(0, 1).toUpperCase() + categoriaDisplay.substring(1);
            %>
            <tr class="<%= categoriaClass %>">
                <td><%= id %></td>
                <td><strong><%= nombre %></strong></td>
                <td><%= descripcion %></td>
                <td><%= categoriaDisplay %></td>
                <td><%= marca != null ? marca : "" %></td>
                <td>$<%= df.format(precio) %></td>
                <td class="<%= stockClass %>"><%= stock %></td>
                <td>$<%= df.format(valorStock) %></td>
                <td><%= codigoBarras != null ? codigoBarras : "" %></td>
                <td><%= prescripcion ? "Sí" : "No" %></td>
                <td style="text-transform: uppercase;"><%= estado %></td>
                <td><%= fechaCreacion.substring(0, 10) %></td>
            </tr>
            <%
            }
            %>
        </tbody>
    </table>

    <br><br>

    <h3>Resumen por Categorías</h3>
    <table>
        <thead>
            <tr>
                <th>Categoría</th>
                <th>Cantidad de Productos</th>
                <th>Valor Total</th>
                <th>Stock Total</th>
            </tr>
        </thead>
        <tbody>
            <%
            rs.close();
            pst.close();
            
            pst = con.prepareStatement("SELECT categoria, COUNT(*) as cantidad, SUM(precio * stock) as valor_total, SUM(stock) as stock_total FROM productos WHERE estado = 'activo' GROUP BY categoria ORDER BY valor_total DESC");
            rs = pst.executeQuery();
            
            while (rs.next()) {
                String categoria = rs.getString("categoria");
                int cantidad = rs.getInt("cantidad");
                double valorTotal = rs.getDouble("valor_total");
                int stockTotal = rs.getInt("stock_total");
                
                String categoriaDisplay = categoria.replace("_", " ");
                categoriaDisplay = categoriaDisplay.substring(0, 1).toUpperCase() + categoriaDisplay.substring(1);
            %>
            <tr>
                <td><%= categoriaDisplay %></td>
                <td><%= cantidad %></td>
                <td>$<%= df.format(valorTotal) %></td>
                <td><%= stockTotal %></td>
            </tr>
            <%
            }
            %>
        </tbody>
    </table>

    <br><br>

    <h3>Productos con Stock Bajo (< 20 unidades)</h3>
    <table>
        <thead>
            <tr>
                <th>Nombre</th>
                <th>Categoría</th>
                <th>Stock Actual</th>
                <th>Precio</th>
                <th>Acción Sugerida</th>
            </tr>
        </thead>
        <tbody>
            <%
            rs.close();
            pst.close();
            
            pst = con.prepareStatement("SELECT nombre, categoria, stock, precio FROM productos WHERE stock < 20 AND estado = 'activo' ORDER BY stock ASC");
            rs = pst.executeQuery();
            
            boolean hayStockBajo = false;
            while (rs.next()) {
                hayStockBajo = true;
                String nombre = rs.getString("nombre");
                String categoria = rs.getString("categoria");
                int stock = rs.getInt("stock");
                double precio = rs.getDouble("precio");
                
                String categoriaDisplay = categoria.replace("_", " ");
                categoriaDisplay = categoriaDisplay.substring(0, 1).toUpperCase() + categoriaDisplay.substring(1);
                
                String accionSugerida = stock == 0 ? "REABASTECER URGENTE" : 
                                       stock < 5 ? "Reabastecer Pronto" : "Monitorear";
            %>
            <tr style="background-color: <%= stock == 0 ? "#f8d7da" : "#fff3cd" %>;">
                <td><%= nombre %></td>
                <td><%= categoriaDisplay %></td>
                <td><%= stock %></td>
                <td>$<%= df.format(precio) %></td>
                <td><strong><%= accionSugerida %></strong></td>
            </tr>
            <%
            }
            
            if (!hayStockBajo) {
            %>
            <tr>
                <td colspan="5" style="text-align: center; color: #28a745;">
                    <strong>¡Excelente! No hay productos con stock bajo</strong>
                </td>
            </tr>
            <%
            }
            %>
        </tbody>
    </table>

    <div style="margin-top: 30px; text-align: center; color: #666; font-size: 12px;">
        <p>Reporte generado automáticamente por PharmaPTY</p>
        <p>© 2025 PharmaPTY. Todos los derechos reservados.</p>
    </div>

</body>
</html>

<%
} catch (Exception e) {
    out.println("<h3>Error al generar el reporte de inventario: " + e.getMessage() + "</h3>");
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