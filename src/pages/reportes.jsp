<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>


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
    <title>PharmaPTY | Reportes de Ventas</title>
    <link rel="icon" href="img/coazon.png" />
    <link rel="stylesheet" href="home.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }
        .stat-label {
            color: #666;
            font-size: 1.1em;
        }
        .chart-container {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .chart-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        .download-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        .download-btn {
            background: #28a745;
            color: white;
            padding: 12px 25px;
            margin: 0 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 1em;
        }
        .download-btn:hover {
            background: #218838;
        }
        .download-btn.excel {
            background: #1f7244;
        }
        .download-btn.csv {
            background: #6c757d;
        }
        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .filter-input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn-filter {
            background: #007bff;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
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
            <a href="gestionUsuarios.jsp">Gestión de Usuarios</a>
            <a href="reportes.jsp" class="active">Reportes</a>
            <a href="home.jsp">Ir al Sitio</a>
        </nav>
    </header>

    <main class="admin-panel">
        <div class="header-section">
            <div>
                <h1><i class="fas fa-chart-bar"></i> Reportes de Ventas</h1>
                <p>Análisis y estadísticas del último mes</p>
            </div>
        </div>

        <%
        // Obtener estadísticas de ventas
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        DecimalFormat df = new DecimalFormat("#,##0.00");
        
        double totalVentas = 0;
        int totalProductos = 0;
        double ventaPromedio = 0;
        int ventasHoy = 0;
        
        StringBuilder ventasPorDia = new StringBuilder();
        StringBuilder totalesPorDiaJS = new StringBuilder();
        StringBuilder productosJS = new StringBuilder();
        StringBuilder cantidadesJS = new StringBuilder();
        
        // Declarar variables para métodos de pago fuera del try-catch
        int efectivoCount = 0;
        int tarjetaCount = 0;
        int transferenciaCount = 0;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
            
            // Total de ventas del mes
            pst = con.prepareStatement("SELECT SUM(total) as total, COUNT(*) as cantidad, AVG(total) as promedio FROM ventas WHERE MONTH(fecha_venta) = MONTH(CURDATE()) AND YEAR(fecha_venta) = YEAR(CURDATE())");
            rs = pst.executeQuery();
            if (rs.next()) {
                totalVentas = rs.getDouble("total");
                totalProductos = rs.getInt("cantidad");
                ventaPromedio = rs.getDouble("promedio");
            }
            rs.close();
            pst.close();
            
            // Ventas de hoy
            pst = con.prepareStatement("SELECT COUNT(*) as hoy FROM ventas WHERE DATE(fecha_venta) = CURDATE()");
            rs = pst.executeQuery();
            if (rs.next()) {
                ventasHoy = rs.getInt("hoy");
            }
            rs.close();
            pst.close();
            
            // Ventas por día (últimos 10 días)
            pst = con.prepareStatement("SELECT DATE(fecha_venta) as fecha, SUM(total) as total_dia FROM ventas WHERE fecha_venta >= DATE_SUB(CURDATE(), INTERVAL 10 DAY) GROUP BY DATE(fecha_venta) ORDER BY fecha_venta");
            rs = pst.executeQuery();
            
            List<String> fechas = new ArrayList<>();
            List<Double> totales = new ArrayList<>();
            
            while (rs.next()) {
                fechas.add(rs.getString("fecha"));
                totales.add(rs.getDouble("total_dia"));
            }
            
            // Convertir a formato JavaScript
            for (int i = 0; i < fechas.size(); i++) {
                if (i > 0) {
                    ventasPorDia.append(",");
                    totalesPorDiaJS.append(",");
                }
                ventasPorDia.append("\"" + fechas.get(i) + "\"");
                totalesPorDiaJS.append(totales.get(i));
            }
            
            rs.close();
            pst.close();
            
            // Productos más vendidos
            pst = con.prepareStatement(
    "SELECT p.nombre, SUM(v.cantidad) as total_vendido " +
    "FROM ventas v " +
    "JOIN productos p ON v.producto_id = p.id " +
    "GROUP BY v.producto_id " +
    "ORDER BY total_vendido DESC " +
    "LIMIT 3"
);
            rs = pst.executeQuery();
            
            List<String> productos = new ArrayList<>();
            List<Integer> cantidades = new ArrayList<>();
            
            while (rs.next()) {
                productos.add(rs.getString("nombre"));
                cantidades.add(rs.getInt("total_vendido"));
            }
            
            // Convertir productos y cantidades a JavaScript
            for (int i = 0; i < productos.size(); i++) {
                if (i > 0) {
                    productosJS.append(",");
                    cantidadesJS.append(",");
                }
                productosJS.append("\"" + productos.get(i) + "\"");
                cantidadesJS.append(cantidades.get(i));
            }
            
            rs.close();
            pst.close();
            
            // Métodos de pago
            pst = con.prepareStatement("SELECT metodo_pago, COUNT(*) as cantidad FROM ventas GROUP BY metodo_pago");
            rs = pst.executeQuery();
            
            while (rs.next()) {
                String metodo = rs.getString("metodo_pago");
                int cantidad = rs.getInt("cantidad");
                
                if ("efectivo".equals(metodo)) {
                    efectivoCount = cantidad;
                } else if ("tarjeta".equals(metodo)) {
                    tarjetaCount = cantidad;
                } else if ("transferencia".equals(metodo)) {
                    transferenciaCount = cantidad;
                }
            }
            rs.close();
            pst.close();
            
        } catch (Exception e) {
            e.printStackTrace();
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

        <!-- Estadísticas principales -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">$<%= df.format(totalVentas) %></div>
                <div class="stat-label">Ventas del Mes</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalProductos %></div>
                <div class="stat-label">Productos Vendidos</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">$<%= df.format(ventaPromedio) %></div>
                <div class="stat-label">Venta Promedio</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= ventasHoy %></div>
                <div class="stat-label">Ventas Hoy</div>
            </div>
        </div>

        <!-- Filtros -->
        <div class="filter-section">
            <label><strong>Filtrar reportes:</strong></label>
            <input type="date" class="filter-input" id="fechaInicio" value="2025-01-01">
            <input type="date" class="filter-input" id="fechaFin" value="2025-01-31">
            <button class="btn-filter" onclick="actualizarReportes()">
                <i class="fas fa-search"></i> Filtrar
            </button>
        </div>

        <!-- Gráficas -->
        <div class="chart-grid">
            <div class="chart-container">
                <h3><i class="fas fa-line-chart"></i> Ventas por Día (Últimos 10 días)</h3>
                <canvas id="ventasChart" width="400" height="200"></canvas>
            </div>
            
            <div class="chart-container">
                <h3><i class="fas fa-pie-chart"></i> Métodos de Pago</h3>
                <canvas id="metodosChart" width="300" height="300"></canvas>
            </div>
        </div>

        <div class="chart-container">
            <h3><i class="fas fa-bar-chart"></i> Productos Más Vendidos</h3>
            <canvas id="productosChart" width="400" height="200"></canvas>
        </div>

        <!-- Sección de descarga -->
        <div class="download-section">
            <h3><i class="fas fa-download"></i> Descargar Reportes</h3>
            <p>Exporta los datos de ventas en diferentes formatos</p>
            
            <button class="download-btn csv" onclick="descargarCSV()">
                <i class="fas fa-file-csv"></i> Descargar CSV
            </button>
            
            <button class="download-btn excel" onclick="descargarExcel()">
                <i class="fas fa-file-excel"></i> Descargar Excel
            </button>
            
            <button class="download-btn" onclick="imprimirReporte()">
                <i class="fas fa-print"></i> Imprimir Reporte
            </button>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2025 PharmaPTY. Panel de Administración.</p>
        </div>
    </footer>

   <<script>
    // Datos para las gráficas
    const ventasPorDia = <%= ventasPorDia.length() > 0 ? "[" + ventasPorDia.toString() + "]" : "[]" %>;
    const totalesPorDia = <%= totalesPorDiaJS.length() > 0 ? "[" + totalesPorDiaJS.toString() + "]" : "[]" %>;

    console.log("ventasPorDia:", ventasPorDia);
    console.log("totalesPorDia:", totalesPorDia);

    document.addEventListener("DOMContentLoaded", function () {
        // Gráfica de ventas por día
        const ctxVentas = document.getElementById('ventasChart').getContext('2d');
        const ventasChart = new Chart(ctxVentas, {
            type: 'line',
            data: {
                labels: ventasPorDia,
                datasets: [{
                    label: 'Ventas Diarias ($)',
                    data: totalesPorDia,
                    borderColor: 'rgb(102, 126, 234)',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    });
    document.addEventListener("DOMContentLoaded", function () {
        // Gráfica de métodos de pago
        const ctxMetodos = document.getElementById('metodosChart').getContext('2d');
        const metodosChart = new Chart(ctxMetodos, {
            type: 'doughnut',
            data: {
                labels: ['Efectivo', 'Tarjeta', 'Transferencia'],
                datasets: [{
                    data: [<%= efectivoCount %>, <%= tarjetaCount %>, <%= transferenciaCount %>],
                    backgroundColor: ['#28a745', '#007bff', '#ffc107']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true
            }
        });

        // Gráfica de productos más vendidos
        const ctxProductos = document.getElementById('productosChart').getContext('2d');
        const productosChart = new Chart(ctxProductos, {
            type: 'bar',
            data: {
                labels: [<%= productosJS.toString() %>],
                datasets: [{
                    label: 'Cantidad Vendida',
                    data: [<%= cantidadesJS.toString() %>],
                    backgroundColor: 'rgba(102, 126, 234, 0.8)',
                    borderColor: 'rgb(102, 126, 234)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    });
</script>

</body>
</html> 