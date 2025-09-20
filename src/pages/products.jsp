<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>

<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8" />
  <title>PharmaPTY | Productos</title>
  <link rel="icon" href="../../img/coazon.png" />
  <link rel="stylesheet" href="../styles/products.css" />
  <link rel="stylesheet" href="../styles/home.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    .products-container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 20px;
    }
    
    .filters-section {
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      margin-bottom: 30px;
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
      align-items: center;
    }
    
    .filter-group {
      display: flex;
      flex-direction: column;
      gap: 5px;
    }
    
    .filter-group label {
      font-weight: bold;
      color: #333;
      font-size: 0.9em;
    }
    
    .filter-select, .search-input {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 1em;
      min-width: 150px;
    }
    
    .search-input {
      min-width: 250px;
    }
    
    .products-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 25px;
      margin-top: 20px;
    }
    
    .product-card {
      background: white;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
      overflow: hidden;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
      position: relative;
    }
    
    .product-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 25px rgba(0,0,0,0.15);
    }
    
    .product-image {
      width: 100%;
      height: 200px;
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
    }
    
    .product-image img {
      max-width: 80%;
      max-height: 80%;
      object-fit: contain;
    }
    
    .product-image .placeholder {
      color: #6c757d;
      font-size: 3em;
    }
    
    .stock-badge {
      position: absolute;
      top: 10px;
      right: 10px;
      padding: 4px 8px;
      border-radius: 12px;
      font-size: 0.8em;
      font-weight: bold;
      color: white;
    }
    
    .stock-alto {
      background-color: #28a745;
    }
    
    .stock-medio {
      background-color: #ffc107;
      color: #000;
    }
    
    .stock-bajo {
      background-color: #dc3545;
    }
    
    .product-info {
      padding: 20px;
    }
    
    .product-category {
      color: #667eea;
      font-size: 0.8em;
      font-weight: bold;
      text-transform: uppercase;
      margin-bottom: 5px;
    }
    
    .product-name {
      font-size: 1.1em;
      font-weight: bold;
      color: #333;
      margin-bottom: 8px;
      line-height: 1.3;
    }
    
    .product-description {
      color: #666;
      font-size: 0.9em;
      line-height: 1.4;
      margin-bottom: 15px;
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
    
    .product-price {
      font-size: 1.4em;
      font-weight: bold;
      color: #667eea;
      margin-bottom: 10px;
    }
    
    .product-stock {
      font-size: 0.9em;
      color: #666;
      margin-bottom: 15px;
    }
    
    .prescription-required {
      background: #fff3cd;
      color: #856404;
      padding: 5px 10px;
      border-radius: 5px;
      font-size: 0.8em;
      margin-bottom: 15px;
      text-align: center;
    }
    
    .product-actions {
      display: flex;
      gap: 10px;
    }
    
    .btn-add-cart {
      flex: 1;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      padding: 10px;
      border-radius: 5px;
      cursor: pointer;
      font-weight: bold;
      transition: opacity 0.3s ease;
    }
    
    .btn-add-cart:hover {
      opacity: 0.9;
    }
    
    .btn-add-cart:disabled {
      background: #6c757d;
      cursor: not-allowed;
    }
    
    .btn-details {
      background: #28a745;
      color: white;
      border: none;
      padding: 10px 15px;
      border-radius: 5px;
      cursor: pointer;
    }
    
    .no-products {
      text-align: center;
      padding: 60px 20px;
      color: #666;
    }
    
    .no-products i {
      font-size: 4em;
      margin-bottom: 20px;
      color: #ddd;
    }
    
    .products-header {
      text-align: center;
      margin-bottom: 40px;
      padding: 40px 20px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 15px;
    }
    
    .products-header h1 {
      font-size: 2.5em;
      margin-bottom: 10px;
    }
    
    .products-header p {
      font-size: 1.1em;
      opacity: 0.9;
    }
    
    .results-info {
      color: #666;
      margin-bottom: 20px;
      font-size: 0.9em;
    }
    
    @media (max-width: 768px) {
      .filters-section {
        flex-direction: column;
        align-items: stretch;
      }
      
      .filter-group {
        width: 100%;
      }
      
      .filter-select, .search-input {
        width: 100%;
        min-width: auto;
      }
      
      .products-grid {
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 15px;
      }
    }
  </style>
</head>

<body>
  <!-- Header base -->
  <%@ include file="../utils/header.jsp" %>
  
  <!-- INCLUIR MODALES -->
  <%@ include file="../utils/modal.jsp" %>
  
  <!-- Contenido Principal -->
  <main class="products-container">
    <div class="products-header">
      <h1><i class="fas fa-pills"></i> Nuestros Productos</h1>
      <p>Encuentra todos los medicamentos y productos de salud que necesitas</p>
    </div>
    
    <!-- Filtros y Búsqueda -->
    <div class="filters-section">
      <div class="filter-group">
        <label for="searchInput">
          <i class="fas fa-search"></i> Buscar Producto
        </label>
        <input type="text" id="searchInput" class="search-input" 
               placeholder="Buscar por nombre o descripción..." 
               onkeyup="filtrarProductos()">
      </div>
      
      <div class="filter-group">
        <label for="categoryFilter">
          <i class="fas fa-tags"></i> Categoría
        </label>
        <select id="categoryFilter" class="filter-select" onchange="filtrarProductos()">
          <option value="">Todas las categorías</option>
          <option value="medicamentos">Medicamentos</option>
          <option value="vitaminas">Vitaminas</option>
          <option value="cuidado_personal">Cuidado Personal</option>
          <option value="bebes">Bebés</option>
          <option value="primeros_auxilios">Primeros Auxilios</option>
          <option value="otros">Otros</option>
        </select>
      </div>
      
      <div class="filter-group">
        <label for="sortSelect">
          <i class="fas fa-sort"></i> Ordenar por
        </label>
        <select id="sortSelect" class="filter-select" onchange="ordenarProductos()">
          <option value="nombre_asc">Nombre A-Z</option>
          <option value="nombre_desc">Nombre Z-A</option>
          <option value="precio_asc">Precio: Menor a Mayor</option>
          <option value="precio_desc">Precio: Mayor a Menor</option>
          <option value="stock_desc">Mayor Stock</option>
        </select>
      </div>
      
      <div class="filter-group">
        <label for="prescriptionFilter">
          <i class="fas fa-prescription"></i> Receta
        </label>
        <select id="prescriptionFilter" class="filter-select" onchange="filtrarProductos()">
          <option value="">Todos</option>
          <option value="0">Sin receta</option>
          <option value="1">Con receta</option>
        </select>
      </div>
    </div>
    
    <div class="results-info" id="resultsInfo">
      Cargando productos...
    </div>
    
    <!-- Grid de Productos -->
    <div class="products-grid" id="productsGrid">
      <%
      // Obtener productos de la base de datos
      Connection con = null;
      PreparedStatement pst = null;
      ResultSet rs = null;
      DecimalFormat df = new DecimalFormat("#,##0.00");
      
      int totalProductos = 0;
      
      try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmapty", "root", "");
          
          String sql = "SELECT * FROM productos WHERE estado = 'activo' ORDER BY nombre ASC";
          pst = con.prepareStatement(sql);
          rs = pst.executeQuery();
          
          List<Map<String, Object>> productos = new ArrayList<>();
          
          while (rs.next()) {
              Map<String, Object> producto = new HashMap<>();
              producto.put("id", rs.getInt("id"));
              producto.put("nombre", rs.getString("nombre"));
              producto.put("descripcion", rs.getString("descripcion"));
              producto.put("precio", rs.getDouble("precio"));
              producto.put("stock", rs.getInt("stock"));
              producto.put("imagen", rs.getString("imagen"));
              producto.put("categoria", rs.getString("categoria"));
              producto.put("marca", rs.getString("marca"));
              producto.put("prescripcion_requerida", rs.getBoolean("prescripcion_requerida"));
              productos.add(producto);
          }
          
          totalProductos = productos.size();
          
          if (productos.isEmpty()) {
      %>
          <div class="no-products">
              <i class="fas fa-box-open"></i>
              <h3>No hay productos disponibles</h3>
              <p>Actualmente no tenemos productos en nuestro catálogo.</p>
          </div>
      <%
          } else {
              for (Map<String, Object> producto : productos) {
                  String categoria = (String) producto.get("categoria");
                  String categoriaDisplay = categoria.replace("_", " ");
                  categoriaDisplay = categoriaDisplay.substring(0, 1).toUpperCase() + categoriaDisplay.substring(1);
                  
                  int stock = (Integer) producto.get("stock");
                  String stockClass = stock > 50 ? "stock-alto" : (stock > 20 ? "stock-medio" : "stock-bajo");
                  String stockText = stock > 50 ? "Stock Alto" : (stock > 20 ? "Stock Medio" : "Stock Bajo");
                  
                  double precio = (Double) producto.get("precio");
                  boolean prescripcion = (Boolean) producto.get("prescripcion_requerida");
      %>
          <div class="product-card" 
               data-nombre="<%= ((String) producto.get("nombre")).toLowerCase() %>"
               data-descripcion="<%= ((String) producto.get("descripcion")).toLowerCase() %>"
               data-categoria="<%= categoria %>"
               data-precio="<%= precio %>"
               data-stock="<%= stock %>"
               data-prescripcion="<%= prescripcion ? 1 : 0 %>">
               
              <div class="product-image">
                  <div class="stock-badge <%= stockClass %>"><%= stockText %></div>
                  <i class="fas fa-pills placeholder"></i>
                  <!-- La imagen se cargaría desde: <%= producto.get("imagen") %> -->
              </div>
              
              <div class="product-info">
                  <div class="product-category"><%= categoriaDisplay %></div>
                  <div class="product-name"><%= producto.get("nombre") %></div>
                  <div class="product-description"><%= producto.get("descripcion") %></div>
                  
                  <% if (prescripcion) { %>
                  <div class="prescription-required">
                      <i class="fas fa-prescription-bottle-alt"></i> Requiere Receta Médica
                  </div>
                  <% } %>
                  
                  <div class="product-price">$<%= df.format(precio) %></div>
                  <div class="product-stock">
                      <i class="fas fa-box"></i> Stock: <%= stock %> unidades
                  </div>
                  
                  <div class="product-actions">
                      <button class="btn-add-cart" <%= stock == 0 ? "disabled" : "" %>>
                          <i class="fas fa-cart-plus"></i> 
                          <%= stock == 0 ? "Agotado" : "Agregar al Carrito" %>
                      </button>
                      <button class="btn-details" onclick="verDetalles(<%= producto.get("id") %>)">
                          <i class="fas fa-eye"></i>
                      </button>
                  </div>
              </div>
          </div>
      <%
              }
          }
      } catch (Exception e) {
          e.printStackTrace();
      %>
          <div class="no-products">
              <i class="fas fa-exclamation-triangle"></i>
              <h3>Error al cargar productos</h3>
              <p>No se pudieron cargar los productos. Por favor, intenta más tarde.</p>
              <p style="font-size: 0.8em; color: #dc3545;">Error: <%= e.getMessage() %></p>
          </div>
      <%
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
    </div>
  </main>

  <!-- Footer base -->
  <%@ include file="../utils/footer.jsp" %>
  <script>
    // Total de productos inicial
    let totalProductosInicial = <%= totalProductos %>;
    
    // Actualizar información de resultados
    function actualizarResultados() {
        const productCards = document.querySelectorAll('.product-card');
        const visibleCards = Array.from(productCards).filter(card => 
            card.style.display !== 'none'
        );
        
        const resultsInfo = document.getElementById('resultsInfo');
        resultsInfo.textContent = `Mostrando ${visibleCards.length} de ${totalProductosInicial} productos`;
    }
    
    // Función de filtrado
    function filtrarProductos() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const categoryFilter = document.getElementById('categoryFilter').value;
        const prescriptionFilter = document.getElementById('prescriptionFilter').value;
        
        const productCards = document.querySelectorAll('.product-card');
        
        productCards.forEach(card => {
            const nombre = card.dataset.nombre;
            const descripcion = card.dataset.descripcion;
            const categoria = card.dataset.categoria;
            const prescripcion = card.dataset.prescripcion;
            
            let mostrar = true;
            
            // Filtro de búsqueda
            if (searchTerm && !nombre.includes(searchTerm) && !descripcion.includes(searchTerm)) {
                mostrar = false;
            }
            
            // Filtro de categoría
            if (categoryFilter && categoria !== categoryFilter) {
                mostrar = false;
            }
            
            // Filtro de prescripción
            if (prescriptionFilter && prescripcion !== prescriptionFilter) {
                mostrar = false;
            }
            
            card.style.display = mostrar ? 'block' : 'none';
        });
        
        actualizarResultados();
    }
    
    // Función de ordenamiento
    function ordenarProductos() {
        const sortValue = document.getElementById('sortSelect').value;
        const productsGrid = document.getElementById('productsGrid');
        const productCards = Array.from(document.querySelectorAll('.product-card'));
        
        productCards.sort((a, b) => {
            switch (sortValue) {
                case 'nombre_asc':
                    return a.dataset.nombre.localeCompare(b.dataset.nombre);
                case 'nombre_desc':
                    return b.dataset.nombre.localeCompare(a.dataset.nombre);
                case 'precio_asc':
                    return parseFloat(a.dataset.precio) - parseFloat(b.dataset.precio);
                case 'precio_desc':
                    return parseFloat(b.dataset.precio) - parseFloat(a.dataset.precio);
                case 'stock_desc':
                    return parseInt(b.dataset.stock) - parseInt(a.dataset.stock);
                default:
                    return 0;
            }
        });
        
        // Limpiar y reordenar
        productsGrid.innerHTML = '';
        productCards.forEach(card => productsGrid.appendChild(card));
    }
    
    // Función para ver detalles del producto
    function verDetalles(productId) {
        alert('Ver detalles del producto ID: ' + productId + '\n\nEsta funcionalidad se implementará próximamente.');
    }
    
    // Inicializar
    document.addEventListener('DOMContentLoaded', () => {
        actualizarResultados();
        
        // Efecto header al hacer scroll
        window.addEventListener("scroll", () => {
            const header = document.querySelector(".sticky-header");
            header.classList.toggle("scrolled", window.scrollY > 50);
        });
        
        // Agregar eventos a botones de carrito
        document.querySelectorAll('.btn-add-cart').forEach(btn => {
            if (!btn.disabled) {
                btn.addEventListener('click', function() {
                    const productCard = this.closest('.product-card');
                    const nombre = productCard.querySelector('.product-name').textContent;
                    
                    // Animación de éxito
                    this.innerHTML = '<i class="fas fa-check"></i> Agregado';
                    this.style.background = '#28a745';
                    
                    setTimeout(() => {
                        this.innerHTML = '<i class="fas fa-cart-plus"></i> Agregar al Carrito';
                        this.style.background = '';
                    }, 2000);
                    
                    // Aquí se implementaría la lógica real del carrito
                    console.log('Producto agregado al carrito:', nombre);
                });
            }
        });
    });
  </script>
</body>

</html>