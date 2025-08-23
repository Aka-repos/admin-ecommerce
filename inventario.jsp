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
    <title>PharmaPTY | Inventario de Productos</title>
    <link rel="icon" href="img/coazon.png" />
    <link rel="stylesheet" href="home.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .admin-panel {
            max-width: 1600px;
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
        .inventory-table {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow-x: auto;
        }
        .table-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }
        .search-box {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            min-width: 300px;
        }
        .btn-add {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
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
            position: sticky;
            top: 0;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .category-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
            color: white;
        }
        .cat-medicamentos { background-color: #dc3545; }
        .cat-vitaminas { background-color: #28a745; }
        .cat-cuidado_personal { background-color: #007bff; }
        .cat-bebes { background-color: #ffc107; color: #000; }
        .cat-primeros_auxilios { background-color: #6c757d; }
        .cat-otros { background-color: #17a2b8; }
        
        .stock-level {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        .stock-alto {
            background-color: #d4edda;
            color: #155724;
        }
        .stock-medio {
            background-color: #fff3cd;
            color: #856404;
        }
        .stock-bajo {
            background-color: #f8d7da;
            color: #721c24;
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
        .product-image-thumb {
            width: 40px;
            height: 40px;
            background: #f8f9fa;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
        }
        .prescription-icon {
            color: #dc3545;
            font-size: 1.2em;
        }
        .filter-section {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .filter-select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .export-buttons {
            display: flex;
            gap: 10px;
        }
        .btn-export {
            background: #17a2b8;
            color: white;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.9em;
        }
        .low-stock-alert {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
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
            <a href="gestionUsuarios.jsp">Usuarios</a>
            <a href="inventario.jsp" class="active">Inventario</a>
            <a href="reportes.jsp">Reportes</a>
            <a href="home.jsp">Ir al Sitio</a>
        </nav>
    </header>

    <main class="admin-panel">
        <div class="header-section">
            <div>
                <h1><i class="fas fa-pills"></i> Inventario de Productos</h1>
                <p>Gestiona todos los productos de la farmacia</p>
            </div>
            <div>
                <a href="agregarProducto.jsp" class="btn-add">
                    <i class="fas fa-plus"></i> Agregar Producto
                </a>
            </div>
        </div>

        <%
        // Obtener estadísticas de productos
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        int totalProductos = 0;
        int productosActivos = 0;
        int stockBajo = 0;
        double valorInventario = 0;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
            
            // Total de productos
            pst = con.prepareStatement("SELECT COUNT(*) as total FROM productos");
            rs = pst.executeQuery();
            if (rs.next()) totalProductos = rs.getInt("total");
            rs.close();
            pst.close();
            
            // Productos activos
            pst = con.prepareStatement("SELECT COUNT(*) as activos FROM productos WHERE estado = 'activo'");
            rs = pst.executeQuery();
            if (rs.next()) productosActivos = rs.getInt("activos");
            rs.close();
            pst.close();
            
            // Stock bajo (menos de 20 unidades)
            pst = con.prepareStatement("SELECT COUNT(*) as bajo FROM productos WHERE stock < 20 AND estado = 'activo'");
            rs = pst.executeQuery();
            if (rs.next()) stockBajo = rs.getInt("bajo");
            rs.close();
            pst.close();
            
            // Valor total del inventario
            pst = con.prepareStatement("SELECT SUM(precio * stock) as valor FROM productos WHERE estado = 'activo'");
            rs = pst.executeQuery();
            if (rs.next()) valorInventario = rs.getDouble("valor");
            rs.close();
            pst.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>

        <div class="stats-cards">
            <div class="stat-card">
                <div class="stat-number"><%= totalProductos %></div>
                <div>Total Productos</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= productosActivos %></div>
                <div>Productos Activos</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color: #dc3545;"><%= stockBajo %></div>
                <div>Stock Bajo</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">$<%= new DecimalFormat("#,##0.00").format(valorInventario) %></div>
                <div>Valor Inventario</div>
            </div>
        </div>

        <% if (stockBajo > 0) { %>
        <div class="low-stock-alert">
            <strong><i class="fas fa-exclamation-triangle"></i> Alerta de Stock Bajo:</strong>
            Hay <%= stockBajo %> productos con stock bajo (menos de 20 unidades). 
            <a href="#" onclick="filtrarStockBajo()" style="color: #721c24; text-decoration: underline;">Ver productos</a>
        </div>
        <% } %>

        <div class="inventory-table">
            <div class="table-controls">
                <div>
                    <input type="text" class="search-box" placeholder="Buscar productos..." 
                           onkeyup="filtrarProductos(this.value)">
                </div>
                
                <div class="filter-section">
                    <select class="filter-select" id="categoryFilter" onchange="filtrarPorCategoria()">
                        <option value="">Todas las categorías</option>
                        <option value="medicamentos">Medicamentos</option>
                        <option value="vitaminas">Vitaminas</option>
                        <option value="cuidado_personal">Cuidado Personal</option>
                        <option value="bebes">Bebés</option>
                        <option value="primeros_auxilios">Primeros Auxilios</option>
                        <option value="otros">Otros</option>
                    </select>
                    
                    <select class="filter-select" id="stockFilter" onchange="filtrarPorStock()">
                        <option value="">Todos los stocks</option>
                        <option value="bajo">Stock Bajo (&lt; 20)</option>
                        <option value="medio">Stock Medio (20-50)</option>
                        <option value="alto">Stock Alto (&gt; 50)</option>
                    </select>
                </div>

                <div class="export-buttons">
                    <a href="exportarInventarioCSV.jsp" class="btn-export">
                        <i class="fas fa-file-csv"></i> CSV
                    </a>
                    <a href="exportarInventarioExcel.jsp" class="btn-export">
                        <i class="fas fa-file-excel"></i> Excel
                    </a>
                </div>
            </div>

            <table id="inventoryTable">
                <thead>
                    <tr>
                        <th>Imagen</th>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Categoría</th>
                        <th>Precio</th>
                        <th>Stock</th>
                        <th>Estado</th>
                        <th>Receta</th>
                        <th>Fecha Creación</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    try {
                        if (con != null) {
                            pst = con.prepareStatement("SELECT * FROM productos ORDER BY fecha_creacion DESC");
                            rs = pst.executeQuery();
                            
                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String nombre = rs.getString("nombre");
                                String categoria = rs.getString("categoria");
                                double precio = rs.getDouble("precio");
                                int stock = rs.getInt("stock");
                                String estado = rs.getString("estado");
                                boolean prescripcion = rs.getBoolean("prescripcion_requerida");
                                String fechaCreacion = rs.getString("fecha_creacion");
                                
                                String stockClass = stock < 20 ? "stock-bajo" : (stock <= 50 ? "stock-medio" : "stock-alto");
                                String stockText = stock < 20 ? "Bajo" : (stock <= 50 ? "Medio" : "Alto");
                                
                                String categoriaClass = "cat-" + categoria;
                                String categoriaDisplay = categoria.replace("_", " ");
                                categoriaDisplay = categoriaDisplay.substring(0, 1).toUpperCase() + categoriaDisplay.substring(1);
                    %>
                    <tr data-categoria="<%= categoria %>" data-stock-level="<%= stock < 20 ? "bajo" : (stock <= 50 ? "medio" : "alto") %>">
                        <td>
                            <div class="product-image-thumb">
                                <i class="fas fa-pills"></i>
                            </div>
                        </td>
                        <td><%= id %></td>
                        <td><strong><%= nombre %></strong></td>
                        <td>
                            <span class="category-badge <%= categoriaClass %>">
                                <%= categoriaDisplay %>
                            </span>
                        </td>
                        <td>$<%= new DecimalFormat("#,##0.00").format(precio) %></td>
                        <td>
                            <span class="stock-level <%= stockClass %>">
                                <%= stock %> (<%= stockText %>)
                            </span>
                        </td>
                        <td>
                            <span style="color: <%= "activo".equals(estado) ? "#28a745" : "#dc3545" %>;">
                                <%= estado.toUpperCase() %>
                            </span>
                        </td>
                        <td>
                            <% if (prescripcion) { %>
                                <i class="fas fa-prescription-bottle-alt prescription-icon" title="Requiere receta"></i>
                            <% } else { %>
                                <i class="fas fa-check" style="color: #28a745;" title="Sin receta"></i>
                            <% } %>
                        </td>
                        <td><%= fechaCreacion.substring(0, 10) %></td>
                        <td>
                            <div class="action-buttons">
                                <a href="verProducto.jsp?id=<%= id %>" class="btn-action btn-view" title="Ver detalles">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="editarProducto.jsp?id=<%= id %>" class="btn-action btn-edit" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="eliminarProducto.jsp?id=<%= id %>" class="btn-action btn-delete" 
                                   title="Eliminar" onclick="return confirm('¿Estás seguro de eliminar este producto?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='10'>Error al cargar productos: " + e.getMessage() + "</td></tr>");
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
        function filtrarProductos(filtro) {
            const tabla = document.getElementById('inventoryTable');
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

        function filtrarPorCategoria() {
            const categoria = document.getElementById('categoryFilter').value;
            const filas = document.querySelectorAll('#inventoryTable tbody tr');
            
            filas.forEach(fila => {
                if (!categoria || fila.dataset.categoria === categoria) {
                    fila.style.display = '';
                } else {
                    fila.style.display = 'none';
                }
            });
        }

        function filtrarPorStock() {
            const stockLevel = document.getElementById('stockFilter').value;
            const filas = document.querySelectorAll('#inventoryTable tbody tr');
            
            filas.forEach(fila => {
                if (!stockLevel || fila.dataset.stockLevel === stockLevel) {
                    fila.style.display = '';
                } else {
                    fila.style.display = 'none';
                }
            });
        }

        function filtrarStockBajo() {
            document.getElementById('stockFilter').value = 'bajo';
            filtrarPorStock();
        }

        // Efecto header al hacer scroll
        window.addEventListener("scroll", () => {
            const header = document.querySelector(".sticky-header");
            header.classList.toggle("scrolled", window.scrollY > 50);
        });
    </script>
</body>
</html>