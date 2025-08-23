<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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

// Obtener ID del producto
String productIdParam = request.getParameter("id");
int productId = 0;
try {
    productId = Integer.parseInt(productIdParam);
} catch (NumberFormatException e) {
    response.sendRedirect("inventario.jsp");
    return;
}

// Obtener datos del producto
Connection con = null;
PreparedStatement pst = null;
ResultSet rs = null;

// Variables para almacenar datos del producto
String nombre = "";
String descripcion = "";
double precio = 0;
int stock = 0;
String categoria = "";
String marca = "";
String codigoBarras = "";
boolean prescripcionRequerida = false;
String estado = "";
String fechaCreacion = "";
String fechaActualizacion = "";

// Variables para estadísticas
int ventasRealizadas = 0;
double ingresosTotales = 0;
int unidadesVendidas = 0;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
    
    // Obtener información del producto
    pst = con.prepareStatement("SELECT * FROM productos WHERE id = ?");
    pst.setInt(1, productId);
    rs = pst.executeQuery();
    
    if (!rs.next()) {
        response.sendRedirect("inventario.jsp");
        return;
    }
    
    nombre = rs.getString("nombre");
    descripcion = rs.getString("descripcion");
    precio = rs.getDouble("precio");
    stock = rs.getInt("stock");
    categoria = rs.getString("categoria");
    marca = rs.getString("marca");
    codigoBarras = rs.getString("codigo_barras");
    prescripcionRequerida = rs.getBoolean("prescripcion_requerida");
    estado = rs.getString("estado");
    fechaCreacion = rs.getString("fecha_creacion");
    fechaActualizacion = rs.getString("fecha_actualizacion");
    
    rs.close();
    pst.close();
    
    // Obtener estadísticas de ventas
    pst = con.prepareStatement("SELECT COUNT(*) as ventas, SUM(total) as ingresos, SUM(cantidad) as unidades FROM ventas WHERE producto LIKE ?");
    pst.setString(1, "%" + nombre + "%");
    rs = pst.executeQuery();
    
    if (rs.next()) {
        ventasRealizadas = rs.getInt("ventas");
        ingresosTotales = rs.getDouble("ingresos");
        unidadesVendidas = rs.getInt("unidades");
    }
    
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("inventario.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaPTY | Detalles del Producto</title>
    <link rel="icon" href="img/coazon.png" />
    <link rel="stylesheet" href="home.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .admin-panel {
            max-width: 1200px;
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
        .product-details {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        .main-info {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .product-image-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        .product-image-placeholder {
            width: 200px;
            height: 200px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: #6c757d;
            font-size: 4em;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .info-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        .info-item h4 {
            margin: 0 0 5px 0;
            color: #333;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-item .value {
            font-size: 1.2em;
            font-weight: bold;
            color: #667eea;
        }
        .description-section {
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .stats-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 0.9em;
            opacity: 0.9;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
            text-transform: uppercase;
        }
        .status-activo {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactivo {
            background-color: #f8d7da;
            color: #721c24;
        }
        .category-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
            color: white;
        }
        .cat-medicamentos { background-color: #dc3545; }
        .cat-vitaminas { background-color: #28a745; }
        .cat-cuidado_personal { background-color: #007bff; }
        .cat-bebes { background-color: #ffc107; color: #000; }
        .cat-primeros_auxilios { background-color: #6c757d; }
        .cat-otros { background-color: #17a2b8; }
        
        .stock-indicator {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            text-align: center;
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
            transition: all 0.3s ease;
        }
        .btn-primary {
            background-color: #667eea;
            color: white;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        .prescription-alert {
            background: #fff3cd;
            color: #856404;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            border-left: 4px solid #ffc107;
        }
        .timeline {
            margin-top: 20px;
        }
        .timeline-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .timeline-icon {
            width: 40px;
            height: 40px;
            background: #667eea;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        @media (max-width: 768px) {
            .product-details {
                grid-template-columns: 1fr;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .action-buttons {
                flex-direction: column;
            }
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
                <span style="color: white; margin-right: 15px;">
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
            <a href="inventario.jsp">Inventario</a>
            <a href="reportes.jsp">Reportes</a>
            <a href="home.jsp">Ir al Sitio</a>
        </nav>
    </header>

    <main class="admin-panel">
        <div class="header-section">
            <div>
                <h1><i class="fas fa-eye"></i> Detalles del Producto</h1>
                <p>Información completa y estadísticas del producto</p>
            </div>
            <div>
                <span class="status-badge status-<%= estado %>">
                    <%= estado.toUpperCase() %>
                </span>
            </div>
        </div>

        <!-- Información Principal -->
        <div class="product-details">
            <div class="main-info">
                <h2 style="margin-top: 0; color: #333;"><%= nombre %></h2>
                
                <% if (marca != null && !marca.isEmpty()) { %>
                <p style="color: #666; font-size: 1.1em; margin-bottom: 20px;">
                    <i class="fas fa-trademark"></i> <strong>Marca:</strong> <%= marca %>
                </p>
                <% } %>
                
                <% if (prescripcionRequerida) { %>
                <div class="prescription-alert">
                    <i class="fas fa-prescription-bottle-alt"></i>
                    <strong>Atención:</strong> Este producto requiere receta médica para su venta.
                </div>
                <% } %>

                <div class="info-grid">
                    <div class="info-item">
                        <h4><i class="fas fa-tag"></i> ID del Producto</h4>
                        <div class="value">#<%= productId %></div>
                    </div>
                    
                    <div class="info-item">
                        <h4><i class="fas fa-th-large"></i> Categoría</h4>
                        <div class="value">
                            <span class="category-badge cat-<%= categoria %>">
                                <%= categoria.replace("_", " ").substring(0, 1).toUpperCase() + categoria.replace("_", " ").substring(1) %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <h4><i class="fas fa-dollar-sign"></i> Precio de Venta</h4>
                        <div class="value">$<%= new DecimalFormat("#,##0.00").format(precio) %></div>
                    </div>
                    
                    <div class="info-item">
                        <h4><i class="fas fa-boxes"></i> Stock Disponible</h4>
                        <div class="value">
                            <div class="stock-indicator <%= stock < 20 ? "stock-bajo" : (stock <= 50 ? "stock-medio" : "stock-alto") %>">
                                <%= stock %> unidades
                            </div>
                        </div>
                    </div>
                    
                    <% if (codigoBarras != null && !codigoBarras.isEmpty()) { %>
                    <div class="info-item">
                        <h4><i class="fas fa-barcode"></i> Código de Barras</h4>
                        <div class="value"><%= codigoBarras %></div>
                    </div>
                    <% } %>
                    
                    <div class="info-item">
                        <h4><i class="fas fa-calculator"></i> Valor en Stock</h4>
                        <div class="value">$<%= new DecimalFormat("#,##0.00").format(precio * stock) %></div>
                    </div>
                </div>

                <div class="description-section">
                    <h4><i class="fas fa-align-left"></i> Descripción del Producto</h4>
                    <p style="line-height: 1.6; color: #555; margin: 10px 0 0 0;"><%= descripcion %></p>
                </div>

                <div class="timeline">
                    <h4><i class="fas fa-clock"></i> Historial del Producto</h4>
                    <div class="timeline-item">
                        <div class="timeline-icon">
                            <i class="fas fa-plus"></i>
                        </div>
                        <div>
                            <strong>Producto creado</strong><br>
                            <small><%= fechaCreacion %></small>
                        </div>
                    </div>
                    <div class="timeline-item">
                        <div class="timeline-icon">
                            <i class="fas fa-edit"></i>
                        </div>
                        <div>
                            <strong>Última actualización</strong><br>
                            <small><%= fechaActualizacion %></small>
                        </div>
                    </div>
                </div>
            </div>

            <div class="product-image-section">
                <div class="product-image-placeholder">
                    <i class="fas fa-pills"></i>
                </div>
                <h4>Imagen del Producto</h4>
                <p style="color: #666; font-size: 0.9em;">
                    La imagen del producto se mostraría aquí cuando esté disponible.
                </p>
                
                <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                    <h4>Acciones Rápidas</h4>
                    <div style="display: flex; flex-direction: column; gap: 10px;">
                        <a href="editarProducto.jsp?id=<%= productId %>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Editar
                        </a>
                        <button class="btn btn-success" onclick="duplicarProducto()">
                            <i class="fas fa-copy"></i> Duplicar
                        </button>
                        <% if ("activo".equals(estado)) { %>
                        <button class="btn btn-secondary" onclick="desactivarProducto()">
                            <i class="fas fa-pause"></i> Desactivar
                        </button>
                        <% } else { %>
                        <button class="btn btn-success" onclick="activarProducto()">
                            <i class="fas fa-play"></i> Activar
                        </button>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Estadísticas de Ventas -->
        <div class="stats-section">
            <h3><i class="fas fa-chart-line"></i> Estadísticas de Ventas</h3>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><%= ventasRealizadas %></div>
                    <div class="stat-label">Ventas Realizadas</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= unidadesVendidas %></div>
                    <div class="stat-label">Unidades Vendidas</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">$<%= new DecimalFormat("#,##0.00").format(ingresosTotales) %></div>
                    <div class="stat-label">Ingresos Generados</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <%= stock > 0 ? new DecimalFormat("#,##0.0").format(((double)(stock - unidadesVendidas) / stock) * 100) + "%" : "N/A" %>
                    </div>
                    <div class="stat-label">Rotación de Stock</div>
                </div>
            </div>
        </div>

        <!-- Botones de Acción -->
        <div class="action-buttons">
            <a href="editarProducto.jsp?id=<%= productId %>" class="btn btn-primary">
                <i class="fas fa-edit"></i> Editar Producto
            </a>
            
            <a href="inventario.jsp" class="btn btn-secondary">
                <i class="fas fa-list"></i> Volver al Inventario
            </a>
            
            <button class="btn btn-success" onclick="imprimirDetalles()">
                <i class="fas fa-print"></i> Imprimir Detalles
            </button>
            
            <a href="eliminarProducto.jsp?id=<%= productId %>" class="btn btn-danger" 
               onclick="return confirm('¿Estás seguro de eliminar este producto?')">
                <i class="fas fa-trash"></i> Eliminar Producto
            </a>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2025 PharmaPTY. Panel de Administración.</p>
        </div>
    </footer>

    <script>
        function duplicarProducto() {
            if (confirm('¿Deseas crear una copia de este producto?')) {
                // Aquí se implementaría la lógica para duplicar
                alert('Funcionalidad de duplicar producto en desarrollo');
            }
        }

        function desactivarProducto() {
            if (confirm('¿Deseas desactivar este producto?\n\nEl producto no aparecerá en el catálogo público.')) {
                // Redirigir a edición con estado inactivo
                window.location.href = 'editarProducto.jsp?id=<%= productId %>&action=deactivate';
            }
        }

        function activarProducto() {
            if (confirm('¿Deseas activar este producto?\n\nEl producto volverá a aparecer en el catálogo público.')) {
                // Redirigir a edición con estado activo
                window.location.href = 'editarProducto.jsp?id=<%= productId %>&action=activate';
            }
        }

        function imprimirDetalles() {
            window.print();
        }

        // Efecto header al hacer scroll
        window.addEventListener("scroll", () => {
            const header = document.querySelector(".sticky-header");
            header.classList.toggle("scrolled", window.scrollY > 50);
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