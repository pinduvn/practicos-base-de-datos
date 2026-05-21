# Prácticos Base de Datos

Base de datos **fábrica** para gestión de ventas de productos y recetas de elaboración con ingredientes y precios.

## Requisitos

- Docker + Docker Compose

## Despliegue

```bash
# Clonar el repositorio
git clone git@github.com:pinduvn/practicos-base-de-datos.git
cd practicos-base-de-datos

# Opción 1: script automático
bash scripts/setup.sh

# Opción 2: manual
docker compose up -d
```

La base de datos se inicializa automáticamente con el esquema y datos de ejemplo.

## Conexión

| Campo     | Valor        |
|-----------|-------------|
| Host      | `localhost` |
| Puerto    | `5432`      |
| Usuario   | `fabrica`   |
| Password  | `fabrica123`|
| Base      | `fabrica`   |

```bash
psql -h localhost -U fabrica -d fabrica
```

## Esquema

- **ingredientes** — insumos con precio unitario y stock
- **productos** — artículos terminados con precio de venta
- **recetas** — composición de cada producto (ingrediente + cantidad)
- **ventas** — cabecera de venta (fecha, total, cliente)
- **detalle_ventas** — ítems vendidos por venta

### Vistas

- `vista_costo_producto` — costo de producción, precio de venta y margen por producto
- `vista_ingredientes_populares` — cantidad de productos que usan cada ingrediente

## Detener

```bash
docker compose down
```
