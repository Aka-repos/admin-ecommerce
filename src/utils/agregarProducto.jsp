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

// Procesar el formulario si se envió
String action = request.getParameter("action");
if ("add".equals(action)) {
    String nombre = request.getParameter("nombre");
    String descripcion = request.getParameter("descripcion");
    String precioStr = request.getParameter("precio");
    String stockStr = request.getParameter("stock");
    String categoria = request.getParameter("categoria");
    String marca = request.getParameter("marca");
    String codigoBarras = request.getParameter("codigo_barras");
    String prescripcionStr = request.getParameter("prescripcion_requerida");
    
    Connection con = null;
    PreparedStatement pst = null;
    
    try {
        double precio = Double.parseDouble(precioStr);
        int stock = Integer.parseInt(stockStr);
        boolean prescripcion = "on".equals(prescripcionStr);
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
        
        String sql = "INSERT INTO productos (nombre, descripcion, precio, stock, categoria, marca, codigo_barras, prescripcion_requerida) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pst = con.prepareStatement(sql);
        pst.setString(1, nombre);
        pst.setString(2, descripcion);
        pst.setDouble(3, precio);
        pst.setInt(4, stock);
        pst.setString(5, categoria);
        pst.setString(6, marca);
        pst.setString(7, codigoBarras);
        pst.setBoolean(8, prescripcion);
        
        int result = pst.executeUpdate();
        
        if (result > 0) {
%>
            <script>
                alert('Producto agregado exitosamente');
                window.location.href = 'inventario.jsp';
            </script>
<%
        } else {
%>
            <script>
                alert('Error al agregar el producto');
            </script>
<%
        }
        
    } catch (NumberFormatException e) {
%>
        <script>
            alert('Error: Precio y stock deben ser números válidos');
        </script>
<%
    } catch (SQLException e) {
        if (e.getMessage().contains("codigo_barras")) {
%>
            <script>
                alert('Error: El código de barras ya existe');
            </script>
<%
        } else {
%>
            <script>
                alert('Error de base de datos: <%= e.getMessage() %>');
            </script>
<%
        }
    } catch (Exception e) {
%>
        <script>
            alert('Error inesperado: <%= e.getMessage() %>');
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
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PharmaPTY | Agregar Producto</title>
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
        .btn:hover {
            opacity: 0.9;
        }
        .required {
            color: #dc3545;
        }
        .form-help {
            font-size: 0.9em;
            color: #666;
            margin-top: 5px;
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
        .category-icons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 10px;
        }
        .category-option {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .category-option:hover {
            border-color: #667eea;
            background-color: #f8f9ff;
        }
        .category-option input[type="radio"] {
            margin: 0;
            width: auto;
        }
        .category-option.selected {
            border-color: #667eea;
            background-color: #f8f9ff;
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .category-icons {
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
                <span style=" margin-right: 15px;">
                    <i class="fas fa-user-shield"></i> Administrador: <%= usuario %>
                </span>
                <a href="logout.jsp" class="login-btn">
                    <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                </a>
            </div>
        </div>
        <nav class="main-nav">
            <a href="/src/pages/admin.jsp">Panel Admin</a>
            <a href="gestionUsuarios.jsp">Usuarios</a>
            <a href="inventario.jsp">Inventario</a>
            <a href="reportes.jsp">Reportes</a>
            <a href="home.jsp">Ir al Sitio</a>
        </nav>
    </header>

    <main class="admin-panel">
        <div class="header-section">
            <h1><i class="fas fa-plus-circle"></i> Agregar Nuevo Producto</h1>
            <p>Completa la información del producto para añadirlo al inventario</p>
        </div>

        <div class="form-container">
            <form method="post" action="agregarProducto.jsp" onsubmit="return validarFormulario()">
                <input type="hidden" name="action" value="add">

                <div class="form-grid">
                    <div class="form-group">
                        <label for="nombre">
                            <i class="fas fa-tag"></i> Nombre del Producto <span class="required">*</span>
                        </label>
                        <input type="text" id="nombre" name="nombre" required 
                               placeholder="Ej: Paracetamol 500mg">
                        <div class="form-help">Nombre comercial completo del producto</div>
                    </div>

                    <div class="form-group">
                        <label for="marca">
                            <i class="fas fa-trademark"></i> Marca
                        </label>
                        <input type="text" id="marca" name="marca" 
                               placeholder="Ej: Bayer, Pfizer">
                    </div>
                </div>

                <div class="form-group full-width">
                    <label for="descripcion">
                        <i class="fas fa-align-left"></i> Descripción <span class="required">*</span>
                    </label>
                    <textarea id="descripcion" name="descripcion" required
                              placeholder="Descripción detallada del producto, usos, presentación, etc."></textarea>
                </div>

                <div class="form-group full-width">
                    <label>
                        <i class="fas fa-th-large"></i> Categoría <span class="required">*</span>
                    </label>
                    <div class="category-icons">
                        <label class="category-option">
                            <input type="radio" name="categoria" value="medicamentos" required>
                            <i class="fas fa-pills" style="color: #dc3545;"></i>
                            <span>Medicamentos</span>
                        </label>
                        <label class="category-option">
                            <input type="radio" name="categoria" value="vitaminas" required>
                            <i class="fas fa-leaf" style="color: #28a745;"></i>
                            <span>Vitaminas</span>
                        </label>
                        <label class="category-option">
                            <input type="radio" name="categoria" value="cuidado_personal" required>
                            <i class="fas fa-hand-sparkles" style="color: #007bff;"></i>
                            <span>Cuidado Personal</span>
                        </label>
                        <label class="category-option">
                            <input type="radio" name="categoria" value="bebes" required>
                            <i class="fas fa-baby" style="color: #ffc107;"></i>
                            <span>Bebés</span>
                        </label>
                        <label class="category-option">
                            <input type="radio" name="categoria" value="primeros_auxilios" required>
                            <i class="fas fa-first-aid" style="color: #6c757d;"></i>
                            <span>Primeros Auxilios</span>
                        </label>
                        <label class="category-option">
                            <input type="radio" name="categoria" value="otros" required>
                            <i class="fas fa-boxes" style="color: #17a2b8;"></i>
                            <span>Otros</span>
                        </label>
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="precio">
                            <i class="fas fa-dollar-sign"></i> Precio <span class="required">*</span>
                        </label>
                        <div class="price-input">
                            <input type="number" id="precio" name="precio" step="0.01" min="0" required 
                                   placeholder="0.00">
                        </div>
                        <div class="form-help">Precio de venta al público</div>
                    </div>

                    <div class="form-group">
                        <label for="stock">
                            <i class="fas fa-boxes"></i> Stock Inicial <span class="required">*</span>
                        </label>
                        <input type="number" id="stock" name="stock" min="0" required 
                               placeholder="0">
                        <div class="form-help">Cantidad inicial en inventario</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="codigo_barras">
                        <i class="fas fa-barcode"></i> Código de Barras
                    </label>
                    <input type="text" id="codigo_barras" name="codigo_barras" 
                           placeholder="Código único del producto">
                    <div class="form-help">Código de barras único (opcional)</div>
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="prescripcion_requerida" name="prescripcion_requerida">
                        <label for="prescripcion_requerida">
                            <i class="fas fa-prescription-bottle-alt"></i> 
                            Requiere Receta Médica
                        </label>
                    </div>
                    <div class="form-help">Marcar si el producto requiere prescripción médica</div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Guardar Producto
                    </button>
                    
                    <a href="inventario.jsp" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancelar
                    </a>
                </div>
            </form>
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
            const categoria = document.querySelector('input[name="categoria"]:checked');

            // Validar campos requeridos
            if (!nombre) {
                alert('El nombre del producto es requerido');
                return false;
            }

            if (!descripcion) {
                alert('La descripción del producto es requerida');
                return false;
            }

            if (!categoria) {
                alert('Debes seleccionar una categoría');
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

        // Manejar selección visual de categorías
        document.querySelectorAll('.category-option').forEach(option => {
            option.addEventListener('click', function() {
                // Remover selección previa
                document.querySelectorAll('.category-option').forEach(opt => {
                    opt.classList.remove('selected');
                });
                
                // Marcar como seleccionado
                this.classList.add('selected');
                
                // Marcar el radio button
                this.querySelector('input[type="radio"]').checked = true;
            });
        });

        // Formatear precio mientras se escribe
        document.getElementById('precio').addEventListener('input', function() {
            let value = this.value;
            if (value && !isNaN(value)) {
                // Limitar a 2 decimales
                if (value.includes('.')) {
                    const parts = value.split('.');
                    if (parts[1] && parts[1].length > 2) {
                        this.value = parts[0] + '.' + parts[1].substring(0, 2);
                    }
                }
            }
        });

        // Generar código de barras automático si está vacío
        document.getElementById('codigo_barras').addEventListener('focus', function() {
            if (!this.value) {
                // Generar un código simple basado en timestamp
                const timestamp = Date.now().toString();
                this.value = '7501' + timestamp.substring(timestamp.length - 9);
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