-- Crear tabla de pedidos para Districarnes
CREATE TABLE IF NOT EXISTS pedido (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER,
    numero_pedido TEXT NOT NULL UNIQUE,
    total NUMERIC(12, 2) NOT NULL,
    subtotal NUMERIC(12, 2) NOT NULL,
    envio NUMERIC(12, 2) NOT NULL DEFAULT 0,
    estado TEXT NOT NULL DEFAULT 'pendiente',
    metodo_pago TEXT NOT NULL DEFAULT 'PayPal',
    paypal_order_id TEXT,
    direccion TEXT,
    ciudad TEXT,
    telefono TEXT,
    nombre_cliente TEXT,
    items JSONB,
    estado_pedido TEXT NOT NULL DEFAULT 'pendiente',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Agregar comentarios a las columnas
COMMENT ON TABLE pedido IS 'Tabla de pedidos de Districarnes';
COMMENT ON COLUMN pedido.id IS 'ID único del pedido';
COMMENT ON COLUMN pedido.id_usuario IS 'ID del usuario que realizó el pedido';
COMMENT ON COLUMN pedido.numero_pedido IS 'Número único del pedido (ej: DC-12345)';
COMMENT ON COLUMN pedido.total IS 'Total del pedido incluyendo envío';
COMMENT ON COLUMN pedido.subtotal IS 'Subtotal sin envío';
COMMENT ON COLUMN pedido.envio IS 'Costo de envío';
COMMENT ON COLUMN pedido.estado IS 'Estado del pago (pendiente, pagado, cancelado, reembolsado)';
COMMENT ON COLUMN pedido.metodo_pago IS 'Método de pago utilizado';
COMMENT ON COLUMN pedido.paypal_order_id IS 'ID de la orden de PayPal';
COMMENT ON COLUMN pedido.direccion IS 'Dirección de entrega';
COMMENT ON COLUMN pedido.ciudad IS 'Ciudad de entrega';
COMMENT ON COLUMN pedido.telefono IS 'Teléfono del cliente';
COMMENT ON COLUMN pedido.nombre_cliente IS 'Nombre completo del cliente';
COMMENT ON COLUMN pedido.items IS 'Lista de productos en formato JSON';
COMMENT ON COLUMN pedido.estado_pedido IS 'Estado del pedido (pendiente, confirmado, en_proceso, enviado, entregado)';
COMMENT ON COLUMN pedido.created_at IS 'Fecha de creación del pedido';
COMMENT ON COLUMN pedido.updated_at IS 'Fecha de última actualización';

-- Crear índice para buscar pedidos por usuario
CREATE INDEX IF NOT EXISTS idx_pedido_usuario ON pedido(id_usuario);

-- Crear índice para buscar pedidos por número
CREATE INDEX IF NOT EXISTS idx_pedido_numero ON pedido(numero_pedido);

-- Crear índice para buscar pedidos por fecha
CREATE INDEX IF NOT EXISTS idx_pedido_fecha ON pedido(created_at DESC);

-- Habilitar Row Level Security (RLS)
ALTER TABLE pedido ENABLE ROW LEVEL SECURITY;

-- Política para que usuarios puedan ver sus propios pedidos
CREATE POLICY "Usuarios ven sus propios pedidos" ON pedido
    FOR SELECT
    USING (id_usuario = auth.uid());

-- Política para que usuarios puedan insertar sus propios pedidos
CREATE POLICY "Usuarios crean pedidos" ON pedido
    FOR INSERT
    WITH CHECK (id_usuario = auth.uid() OR id_usuario IS NULL);
