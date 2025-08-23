<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
// Verificar que el usuario esté logueado y sea admin
String rol = (String) session.getAttribute("rol");
Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");

if (loggedIn == null || !loggedIn || rol == null || !rol.equals("admin")) {
    response.sendRedirect("home.jsp");
    return;
}

// Configurar respuesta para descarga de CSV
response.setContentType("text/csv");
response.setHeader("Content-Disposition", "attachment; filename=\"reporte_ventas_" + 
    new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + ".csv\"");

Connection con = null;
PreparedStatement pst = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
    
    // Escribir encabezados del CSV
    out.println("ID,Fecha Venta,Cliente ID,Producto,Cantidad,Precio Unitario,Total,Método Pago,Estado");
    
    // Consultar todas las ventas
    String sql = "SELECT v.*, u.nombre_usuario FROM ventas v " +
                 "LEFT JOIN usuarios u ON v.cliente_id = u.id " +
                 "ORDER BY v.fecha_venta DESC";
    
    pst = con.prepareStatement(sql);
    rs = pst.executeQuery();
    
    while (rs.next()) {
        // Escribir cada fila del CSV
        out.println(
            rs.getInt("id") + "," +
            rs.getString("fecha_venta") + "," +
            (rs.getString("nombre_usuario") != null ? rs.getString("nombre_usuario") : "N/A") + "," +
            "\"" + rs.getString("producto") + "\"," +
            rs.getInt("cantidad") + "," +
            rs.getDouble("precio_unitario") + "," +
            rs.getDouble("total") + "," +
            rs.getString("metodo_pago") + "," +
            rs.getString("estado")
        );
    }
    
} catch (Exception e) {
    out.println("Error al generar CSV: " + e.getMessage());
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