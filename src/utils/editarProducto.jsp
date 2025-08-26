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

// Obtener ID del producto a editar
String productIdParam = request.getParameter("id");
int productId = 0;
try {
    productId = Integer.parseInt(productIdParam);
} catch (NumberFormatException e) {
    response.sendRedirect("inventario.jsp");
    return;
}

// Procesar actualización si se envió el formulario
String action = request.getParameter("action");
if ("update".equals(action)) {
    String nombre = request.getParameter("nombre");
    String descripcion = request.getParameter("descripcion");
    String precioStr = request.getParameter("precio");
    String stockStr = request.getParameter("stock");
    String categoria = request.getParameter("categoria");
    String marca = request.getParameter("marca");
    String codigoBarras = request.getParameter("codigo_barras");
    String prescripcionStr = request.getParameter("prescripcion_requerida");
    String estado = request.getParameter("estado");
    
    Connection con = null;
    PreparedStatement pst = null;
    
    try {
        double precio = Double.parseDouble(precioStr);
        int stock = Integer.parseInt(stockStr);
        boolean prescripcion = "on".equals(prescripcionStr);
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
        
        String sql = "UPDATE productos SET nombre=?, descripcion=?, precio=?, stock=?, categoria=?, marca=?, codigo_barras=?, prescripcion_requerida=?, estado=? WHERE id=?";
        pst = con.prepareStatement(sql);
        pst.setString(1, nombre);
        pst.setString(2, descripcion);
        pst.setDouble(3, precio);
        pst.setInt(4, stock);
        pst.setString(5, categoria);
        pst.setString(6, marca);
        pst.setString(7, codigoBarras);
        pst.setBoolean(8, prescripcion);
        pst.setString(9, estado);
        pst.setInt(10, productId);
        
        int result = pst.executeUpdate();
        
        if (result > 0) {
%>
            <script>
                alert('Producto actualizado exitosamente');
                window.location.href = 'inventario.jsp';
            </script>
<%
        } else {
%>
            <script>
                alert('Error al actualizar el producto');
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

// Obtener datos del producto
Connection con = null;
PreparedStatement pst = null;
ResultSet rs = null;

String nombreActual = "";
String descripcionActual = "";
double precioActual = 0;
int stockActual = 0;
String categoriaActual = "";
String marcaActual = "";
String codigoBarrasActual = "";
boolean prescripcionActual = false;
String estadoActual = "";
String fechaCreacion = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
    
    pst = con.prepareStatement("SELECT * FROM productos WHERE id = ?");
    pst.setInt(1, productId);
    rs = pst.executeQuery();
    
    if (rs.next()) {
        nombreActual = rs.getString("nombre");
        descripcionActual = rs.getString("descripcion");
        precioActual = rs.getDouble("precio");
        stockActual = rs.getInt("stock");
        categoriaActual = rs.getString("categoria");
        marcaActual = rs.getString("marca");
        codigoBarrasActual = rs.getString("codigo_barras");
        prescripcionActual = rs.getBoolean("prescripcion_requerida");
        estadoActual = rs.getString("estado");
        fechaCreacion = rs.getString("fecha_creacion");
    } else {
        response.sendRedirect("inventario.jsp");
        return;
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
    <title>PharmaPTY | Editar Producto</title>
    <link rel="icon" href="img/coazon.png" />
    <link rel="stylesheet" href="home.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .admin-panel {
            max-width: 900px;
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
        .product-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            box-sizing: border-box;
        }
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin: 0;
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
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .required {
            color: #dc3545;
        }
        .price-input {
            position: relative;
        }
        .price-input::before {
            content: '$';
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            z-index: 1;
        }
        .price-input input {
            padding-left: 25px;
        }
        .status-toggle {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .status-toggle label {
            display: flex;
            align-items: center;
            gap: 5px;
            cursor: pointer;
            padding: 8px 15px;
            border: 2px solid #ddd;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        .status-toggle input[type="radio"] {
            margin: 0;
            width: auto;
        }
        .status-toggle label:hover {
            border-color: #667eea;
        }
        .status-toggle label.selected {
            border-color: #667eea;
            background-color: #f8f9ff;
        }
        .danger-zone {
            border: 2px solid #dc3545;
            border-radius: 10px;
            padding: 20px;
            margin-top: 30px;
            background-color: #f8f9fa;
        }
        .danger-zone h4 {
            color: #dc3545;
            margin-bottom: 15px;
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
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
            <h1><i class="fas fa-edit"></i> Editar Producto</h1>
            <p>Modifica la información del producto seleccionado</p>
        </div>

        <div class="form-container">
            <div class="product-info">
                <h3><i class="fas fa-info-circle"></i> Información del Producto</h3>
                <p><strong>ID:</strong> <%= productId %></p>
                <p><strong>Fecha de Creación:</strong> <%= fechaCreacion %></p>
                <p><strong>Estado Actual:</strong> 
                    <span style="color: <%= "activo".equals(estadoActual) ? "#28a745" : "#dc3545" %>;">
                        <%= estadoActual.toUpperCase() %>
                    </span>
                </p>
            </div>

            <form method="post" action="editarProducto.jsp" onsubmit="return validarFormulario()">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= productId %>">

                <div class="form-grid">
                    <div class="form-group">
                        <label for="nombre">
                            <i class="fas fa-tag"></i> Nombre del Producto <span class="required">*</span>
                        </label>
                        <input type="text" id="nombre" name="nombre" value="<%= nombreActual %>" required>
                    </div>

                    <div class="form-group">
                        <label for="marca">
                            <i class="fas fa-trademark"></i> Marca
                        </label>
                        <input type="text" id="marca" name="marca" value="<%= marcaActual != null ? marcaActual : "" %>">
                    </div>
                </div>

                <div class="form-group full-width">
                    <label for="descripcion">
                        <i class="fas fa-align-left"></i> Descripción <span class="required">*</span>
                    </label>
                    <textarea id="descripcion" name="descripcion" required><%= descripcionActual %></textarea>
                </div>

                <div class="form-group">
                    <label for="categoria">
                        <i class="fas fa-th-large"></i> Categoría <span class="required">*</span>
                    </label>
                    <select id="categoria" name="categoria" required>
                        <option value="medicamentos" <%= "medicamentos".equals(categoriaActual) ? "selected" : "" %>>Medicamentos</option>
                        <option value="vitaminas" <%= "vitaminas".equals(categoriaActual) ? "selected" : "" %>>Vitaminas</option>
                        <option value="cuidado_personal" <%= "cuidado_personal".equals(categoriaActual) ? "selected" : "" %>>Cuidado Personal</option>
                        <option value="bebes" <%= "bebes".equals(categoriaActual) ? "selected" : "" %>>Bebés</option>
                        <option value="primeros_auxilios" <%= "primeros_auxilios".equals(categoriaActual) ? "selected" : "" %>>Primeros Auxilios</option>
                        <option value="otros" <%= "otros".equals(categoriaActual) ? "selected" : "" %>>Otros</option>
                    </select>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="precio">
                            <i class="fas fa-dollar-sign"></i> Precio <span class="required">*</span>
                        </label>
                        <div class="price-input">
                            <input type="number" id="precio" name="precio" step="0.01" min="0" 
                                   value="<%= precioActual %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="stock">
                            <i class="fas fa-boxes"></i> Stock <span class="required">*</span>
                        </label>
                        <input type="number" id="stock" name="stock" min="0" 
                               value="<%= stockActual %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="codigo_barras">
                        <i class="fas fa-barcode"></i> Código de Barras
                    </label>
                    <input type="text" id="codigo_barras" name="codigo_barras" 
                           value="<%= codigoBarrasActual != null ? codigoBarrasActual : "" %>">
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="prescripcion_requerida" name="prescripcion_requerida" 
                               <%= prescripcionActual ? "checked" : "" %>>
                        <label for="prescripcion_requerida">
                            <i class="fas fa-prescription-bottle-alt"></i> 
                            Requiere Receta Médica
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-toggle-on"></i> Estado del Producto
                    </label>
                    <div class="status-toggle">
                        <label class="<%= "activo".equals(estadoActual) ? "selected" : "" %>">
                            <input type="radio" name="estado" value="activo" 
                                   <%= "activo".equals(estadoActual) ? "checked" : "" %>>
                            <i class="fas fa-check-circle" style="color: #28a745;"></i>
                            Activo
                        </label>
                        <label class="<%= "inactivo".equals(estadoActual) ? "selected" : "" %>">
                            <input type="radio" name="estado" value="inactivo" 
                                   <%= "inactivo".equals(estadoActual) ? "checked" : "" %>>
                            <i class="fas fa-times-circle" style="color: #dc3545;"></i>
                            Inactivo
                        </label>
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Guardar Cambios
                    </button>
                    
                    <a href="inventario.jsp" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancelar
                    </a>
                    
                    <a href="verProducto.jsp?id=<%= productId %>" class="btn btn-secondary">
                        <i class="fas fa-eye"></i> Ver Detalles
                    </a>
                </div>
            </form>

            <div class="danger-zone">
                <h4><i class="fas fa-exclamation-triangle"></i> Zona de Peligro</h4>
                <p>Las siguientes acciones son irreversibles y pueden afectar el inventario.</p>
                <div style="margin-top: 15px;">
                    <a href="eliminarProducto.jsp?id=<%= productId %>" class="btn btn-danger" 
                       onclick="return confirm('¿Estás completamente seguro de eliminar este producto?\n\nEsta acción NO se puede deshacer.')">
                        <i class="fas fa-trash"></i> Eliminar Producto
                    </a>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2025 PharmaPTY. Panel de Administración.</p>
        </div>
    </footer>

    <script>
        function validarFormulario() {
            const nombre = document.getElementById('nombre').value.trim();
            const descripcion = document.getElementById('descripcion').value.trim();
            const precio = document.getElementById('precio').value;
            const stock = document.getElementById('stock').value;

            if (!nombre) {
                alert('El nombre del producto es requerido');
                return false;
            }

            if (!descripcion) {
                alert('La descripción del producto es requerida');
                return false;
            }

            if (!precio || parseFloat(precio) < 0) {
                alert('El precio debe ser un número válido mayor o igual a 0');
                return false;
            }

            if (!stock || parseInt(stock) < 0) {
                alert('El stock debe ser un número válido mayor o igual a 0');
                return false;
            }

            return true;
        }

        // Manejar selección visual de estado
        document.querySelectorAll('.status-toggle input[type="radio"]').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.status-toggle label').forEach(label => {
                    label.classList.remove('selected');
                });
                this.closest('label').classList.add('selected');
            });
        });

        // Confirmación antes de enviar
        document.querySelector('form').addEventListener('submit', function(e) {
            if (!confirm('¿Estás seguro de que deseas actualizar este producto?')) {
                e.preventDefault();
            }
        });

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