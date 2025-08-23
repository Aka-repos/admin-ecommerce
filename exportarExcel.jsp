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
response.setHeader("Content-Disposition", "attachment; filename=\"reporte_ventas_" + 
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
    <title>Reporte de Ventas PharmaPTY</title>
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
        .total-row {
            background-color: #e9ecef;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>PharmaPTY - Reporte de Ventas</h1>
        <h3>Generado el: <%= new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()) %></h3>
    </div>

    <%
    // Obtener estadísticas generales
    double totalVentas = 0;
    int totalTransacciones = 0;
    double ventaPromedio = 0;
    
    pst = con.prepareStatement("SELECT SUM(total) as total, COUNT(*) as cantidad, AVG(total) as promedio FROM ventas");
    rs = pst.executeQuery();
    if (rs.next()) {
        totalVentas = rs.getDouble("total");
        totalTransacciones = rs.getInt("cantidad");
        ventaPromedio = rs.getDouble("promedio");
    }
    rs.close();
    pst.close();
    %>

    <div class="summary">
        <h3>Resumen Ejecutivo</h3>
        <p><strong>Total de Ventas:</strong> $<%= df.format(totalVentas) %></p>
        <p><strong>Número de Transacciones:</strong> <%= totalTransacciones %></p>
        <p><strong>Venta Promedio:</strong> $<%= df.format(ventaPromedio) %></p>
        <p><strong>Período:</strong> Todos los registros</p>
    </div>

    <h3>Detalle de Ventas</h3>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Fecha</th>
                <th>Cliente</th>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio Unitario</th>
                <th>Total</th>
                <th>Método de Pago</th>
                <th>Estado</th>
            </tr>
        </thead>
        <tbody>
            <%
            // Consultar todas las ventas con información del cliente
            String sql = "SELECT v.*, u.nombre_usuario FROM ventas v " +
                         "LEFT JOIN usuarios u ON v.cliente_id = u.id " +
                         "ORDER BY v.fecha_venta DESC";
            
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                String metodoPago = rs.getString("metodo_pago");
                String estado = rs.getString("estado");
                String cliente = rs.getString("nombre_usuario") != null ? rs.getString("nombre_usuario") : "Cliente N/A";
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("fecha_venta") %></td>
                <td><%= cliente %></td>
                <td><%= rs.getString("producto") %></td>
                <td><%= rs.getInt("cantidad") %></td>
                <td>$<%= df.format(rs.getDouble("precio_unitario")) %></td>
                <td>$<%= df.format(rs.getDouble("total")) %></td>
                <td style="text-transform: capitalize;"><%= metodoPago %></td>
                <td style="text-transform: capitalize;"><%= estado %></td>
            </tr>
            <%
            }
            %>
            <tr class="total-row">
                <td colspan="6"><strong>TOTAL GENERAL</strong></td>
                <td><strong>$<%= df.format(totalVentas) %></strong></td>
                <td colspan="2"></td>
            </tr>
        </tbody>
    </table>

    <br><br>

    <h3>Resumen por Método de Pago</h3>
    <table>
        <thead>
            <tr>
                <th>Método de Pago</th>
                <th>Cantidad de Transacciones</th>
                <th>Total Vendido</th>
                <th>Porcentaje</th>
            </tr>
        </thead>
        <tbody>
            <%
            rs.close();
            pst.close();
            
            pst = con.prepareStatement("SELECT metodo_pago, COUNT(*) as cantidad, SUM(total) as total_metodo FROM ventas GROUP BY metodo_pago ORDER BY total_metodo DESC");
            rs = pst.executeQuery();
            
            while (rs.next()) {
                String metodo = rs.getString("metodo_pago");
                int cantidad = rs.getInt("cantidad");
                double totalMetodo = rs.getDouble("total_metodo");
                double porcentaje = (totalMetodo / totalVentas) * 100;
            %>
            <tr>
                <td style="text-transform: capitalize;"><%= metodo %></td>
                <td><%= cantidad %></td>
                <td>$<%= df.format(totalMetodo) %></td>
                <td><%= df.format(porcentaje) %>%</td>
            </tr>
            <%
            }
            %>
        </tbody>
    </table>

    <br><br>

    <h3>Productos Más Vendidos</h3>
    <table>
        <thead>
            <tr>
                <th>Producto</th>
                <th>Cantidad Total Vendida</th>
                <th>Ingresos Generados</th>
                <th>Precio Promedio</th>
            </tr>
        </thead>
        <tbody>
            <%
            rs.close();
            pst.close();
            
            pst = con.prepareStatement("SELECT producto, SUM(cantidad) as total_cantidad, SUM(total) as total_ingresos, AVG(precio_unitario) as precio_promedio FROM ventas GROUP BY producto ORDER BY total_cantidad DESC LIMIT 10");
            rs = pst.executeQuery();
            
            while (rs.next()) {
                String producto = rs.getString("producto");
                int totalCantidad = rs.getInt("total_cantidad");
                double totalIngresos = rs.getDouble("total_ingresos");
                double precioPromedio = rs.getDouble("precio_promedio");
            %>
            <tr>
                <td><%= producto %></td>
                <td><%= totalCantidad %></td>
                <td>$<%= df.format(totalIngresos) %></td>
                <td>$<%= df.format(precioPromedio) %></td>
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
    out.println("<h3>Error al generar el reporte: " + e.getMessage() + "</h3>");
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