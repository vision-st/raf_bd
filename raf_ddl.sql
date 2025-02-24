

-- Tabla principal de Fiscalización
CREATE TABLE Fiscalizacion (
    id_fiscalizacion INT PRIMARY KEY IDENTITY(1,1),
    fecha_hora DATETIME DEFAULT GETDATE(),
    latitud DECIMAL(10,6),
    longitud DECIMAL(10,6),
    altitud DECIMAL(10,2),
    accuracy DECIMAL(10,2),
    numeroOficina TINYINT NOT NULL DEFAULT 0, -- Cambio realizado
    observaciones_generales TEXT,
    mostrar_id VARCHAR(50) NULL -- ID del formulario ODK si es necesario
);

-- Unidades Técnicas
CREATE TABLE UnidadTecnica (
    id_unidad_tecnica INT PRIMARY KEY IDENTITY(1,1),
    nombre_unidad_tecnica VARCHAR(100) NOT NULL
);

CREATE TABLE FiscalizacionUnidadTecnica (
    id_fiscalizacion INT NOT NULL,
    id_unidad_tecnica INT NOT NULL,
    PRIMARY KEY (id_fiscalizacion, id_unidad_tecnica),
    FOREIGN KEY (id_fiscalizacion) REFERENCES Fiscalizacion(id_fiscalizacion),
    FOREIGN KEY (id_unidad_tecnica) REFERENCES UnidadTecnica(id_unidad_tecnica)
);

-- Tipos de Actividad
CREATE TABLE TipoActividad (
    id_tipo_actividad INT PRIMARY KEY IDENTITY(1,1),
    nombre_tipo_actividad VARCHAR(100) NOT NULL
);

CREATE TABLE FiscalizacionTipoActividad (
    id_fiscalizacion INT NOT NULL,
    id_tipo_actividad INT NOT NULL,
    PRIMARY KEY (id_fiscalizacion, id_tipo_actividad),
    FOREIGN KEY (id_fiscalizacion) REFERENCES Fiscalizacion(id_fiscalizacion),
    FOREIGN KEY (id_tipo_actividad) REFERENCES TipoActividad(id_tipo_actividad)
);

-- Orígenes de Actividad
CREATE TABLE OrigenActividad (
    id_origen_actividad INT PRIMARY KEY IDENTITY(1,1),
    nombre_origen_actividad VARCHAR(100) NOT NULL
);

CREATE TABLE FiscalizacionOrigenActividad (
    id_fiscalizacion INT NOT NULL,
    id_origen_actividad INT NOT NULL,
    PRIMARY KEY (id_fiscalizacion, id_origen_actividad),
    FOREIGN KEY (id_fiscalizacion) REFERENCES Fiscalizacion(id_fiscalizacion),
    FOREIGN KEY (id_origen_actividad) REFERENCES OrigenActividad(id_origen_actividad)
);

-- Vías de Fiscalización
CREATE TABLE ViaFiscalizacion (
    id_via_fiscalizacion INT PRIMARY KEY IDENTITY(1,1),
    nombre_via_fiscalizacion VARCHAR(100) NOT NULL
);

CREATE TABLE FiscalizacionViaFiscalizacion (
    id_fiscalizacion INT NOT NULL,
    id_via_fiscalizacion INT NOT NULL,
    PRIMARY KEY (id_fiscalizacion, id_via_fiscalizacion),
    FOREIGN KEY (id_fiscalizacion) REFERENCES Fiscalizacion(id_fiscalizacion),
    FOREIGN KEY (id_via_fiscalizacion) REFERENCES ViaFiscalizacion(id_via_fiscalizacion)
);

-- Relación entre Fiscalización e Instituciones Participantes
CREATE TABLE Instituciones (
    id_institucion INT PRIMARY KEY IDENTITY(1,1),
    nombre_institucion VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE FiscalizacionInstitucion (
    id_fiscalizacion INT NOT NULL,
    id_institucion INT NOT NULL,
    PRIMARY KEY (id_fiscalizacion, id_institucion),
    FOREIGN KEY (id_fiscalizacion) REFERENCES Fiscalizacion(id_fiscalizacion),
    FOREIGN KEY (id_institucion) REFERENCES Instituciones(id_institucion)
);

-- Agentes Fiscalizados (SE MUEVE ANTES DE HALLAZGOS)
CREATE TABLE TipoAgente (
    id_tipo_agente INT PRIMARY KEY IDENTITY(1,1),
    nombre_tipo_agente VARCHAR(100) NOT NULL
);

CREATE TABLE AgentesFiscalizados (
    id_agente INT PRIMARY KEY IDENTITY(1,1),
    id_fiscalizacion INT NOT NULL,
    id_tipo_agente INT NOT NULL
    FOREIGN KEY (id_fiscalizacion) REFERENCES Fiscalizacion(id_fiscalizacion),
    FOREIGN KEY (id_tipo_agente) REFERENCES TipoAgente(id_tipo_agente)
);

-- Acciones de Fiscalización
CREATE TABLE AccionFiscalizacion (
    id_accion INT PRIMARY KEY IDENTITY(1,1),
    id_fiscalizacion INT NOT NULL,
    comuna VARCHAR(100),
    latitud DECIMAL(10,6),
    longitud DECIMAL(10,6),
    altitud DECIMAL(10,2),
    accuracy DECIMAL(10,2),
    lugar VARCHAR(255),
    ubicacion_manual TEXT,
    FOREIGN KEY (id_fiscalizacion) REFERENCES Fiscalizacion(id_fiscalizacion)
);

-- Hallazgos (Ahora AgentesFiscalizados EXISTE antes de esta tabla)
CREATE TABLE Hallazgos (
    id_hallazgo INT PRIMARY KEY IDENTITY(1,1),
    id_accion INT NOT NULL,
    id_agente INT NOT NULL, 
    FOREIGN KEY (id_accion) REFERENCES AccionFiscalizacion(id_accion),
    FOREIGN KEY (id_agente) REFERENCES AgentesFiscalizados(id_agente)
);


CREATE TABLE EspeciesLegales (
    id_especie_encontrada INT PRIMARY KEY IDENTITY(1,1),
    id_accion INT NOT NULL,
    id_especie INT NOT NULL,
    categoria VARCHAR(50) CHECK (categoria IN ('recurso', 'producto')),
    tipo_producto VARCHAR(50),
    cantidad DECIMAL(10,2),
    unidad_medida VARCHAR(50),
    FOREIGN KEY (id_accion) REFERENCES AccionFiscalizacion(id_accion)
);

-- Evidencias
CREATE TABLE Evidencia (
    id_evidencia INT PRIMARY KEY IDENTITY(1,1),
    id_accion INT NOT NULL,
    tipo_evidencia VARCHAR(50) CHECK (tipo_evidencia IN ('image', 'audio', 'video', 'documento')),
    link_evidencia TEXT,
    FOREIGN KEY (id_accion) REFERENCES AccionFiscalizacion(id_accion)
);

-- Cometidos y Funcionarios
CREATE TABLE Cometidos (
    id_cometido INT PRIMARY KEY IDENTITY(1,1),
    id_fiscalizacion INT NOT NULL,
    hora_termino TIME,
    observaciones TEXT,
    foto_evidencia TEXT,
    archivo_evidencia TEXT,
    kilometraje_final INT,
    firma_imagen TEXT,
    FOREIGN KEY (id_fiscalizacion) REFERENCES Fiscalizacion(id_fiscalizacion)
);

CREATE TABLE Funcionarios (
    id_funcionario INT PRIMARY KEY IDENTITY(1,1),
    rut VARCHAR(12) UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    id_institucion INT NOT NULL,
    FOREIGN KEY (id_institucion) REFERENCES Instituciones(id_institucion)
);

CREATE TABLE CometidosFuncionarios (
    id_cometido INT NOT NULL,
    id_funcionario INT NOT NULL,
    PRIMARY KEY (id_cometido, id_funcionario),
    FOREIGN KEY (id_cometido) REFERENCES Cometidos(id_cometido),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario)
);

-- Medidas y su Relación con los Agentes
CREATE TABLE Medida (
    id_medida INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(255) NOT NULL, 
    tipo VARCHAR(50) CHECK (tipo IN ('cumplimiento', 'incumplimiento'))
);

CREATE TABLE AgenteMedida (
    id_agente INT NOT NULL,
    id_medida INT NOT NULL,
    PRIMARY KEY (id_agente, id_medida),
    FOREIGN KEY (id_agente) REFERENCES AgentesFiscalizados(id_agente),
    FOREIGN KEY (id_medida) REFERENCES Medida(id_medida)
);

CREATE TABLE VehiculosFiscalizacion (
    id_vehiculo INT PRIMARY KEY IDENTITY(1,1),
    id_fiscalizacion INT NOT NULL,
    patente VARCHAR(20) NOT NULL,
    tipo_vehiculo VARCHAR(50) NOT NULL, -- Nuevo campo para almacenar el tipo de vehículo
    kilometraje_inicial INT,
    kilometraje_final INT,
    FOREIGN KEY (id_fiscalizacion) REFERENCES Fiscalizacion(id_fiscalizacion)
);

CREATE TABLE CondicionRiesgo (
    id_riesgo INT PRIMARY KEY IDENTITY(1,1),
    nombre_riesgo VARCHAR(255) NOT NULL
);

CREATE TABLE AccionFiscalizacionRiesgo (
    id_accion INT NOT NULL,
    id_riesgo INT NOT NULL,
    PRIMARY KEY (id_accion, id_riesgo),
    FOREIGN KEY (id_accion) REFERENCES AccionFiscalizacion(id_accion),
    FOREIGN KEY (id_riesgo) REFERENCES CondicionRiesgo(id_riesgo)
);

CREATE TABLE AccionFiscalizacionEspecie (
    id_accion INT NOT NULL,
    id_especie INT NOT NULL,
    PRIMARY KEY (id_accion, id_especie),
    FOREIGN KEY (id_accion) REFERENCES AccionFiscalizacion(id_accion)
);

CREATE TABLE EspeciesIlegales (
    id_especie_ilegal INT PRIMARY KEY IDENTITY(1,1),
    id_hallazgo INT NOT NULL,
    id_especie INT NOT NULL,
    categoria VARCHAR(50) CHECK (categoria IN ('recurso', 'producto')),
    tipo_producto VARCHAR(50), -- Tipo de producto si aplica
    cantidad DECIMAL(10,2),
    unidad_medida VARCHAR(50),
    FOREIGN KEY (id_hallazgo) REFERENCES Hallazgos(id_hallazgo)
);

CREATE TABLE ResultadoHallazgo (
    id_resultado INT PRIMARY KEY IDENTITY(1,1),
    nombre_resultado VARCHAR(255) NOT NULL
);
CREATE TABLE HallazgoResultado (
    id_hallazgo INT NOT NULL,
    id_resultado INT NOT NULL,
    PRIMARY KEY (id_hallazgo, id_resultado),
    FOREIGN KEY (id_hallazgo) REFERENCES Hallazgos(id_hallazgo),
    FOREIGN KEY (id_resultado) REFERENCES ResultadoHallazgo(id_resultado)
);
CREATE TABLE EvidenciaHallazgo (
    id_evidencia_hallazgo INT PRIMARY KEY IDENTITY(1,1),
    id_hallazgo INT NOT NULL,
    tipo_evidencia VARCHAR(50) CHECK (tipo_evidencia IN ('image', 'documento')),
    link_evidencia TEXT NOT NULL,
    medio_verificacion_tipo VARCHAR(500) NOT NULL,
    medio_verificacion_folio INT NOT NULL,
    actividad TEXT,
    antecedentes_referencia TEXT,
    observaciones TEXT,
    FOREIGN KEY (id_hallazgo) REFERENCES Hallazgos(id_hallazgo)
);
CREATE TABLE EvidenciaHallazgoMedida (
    id_evidencia_hallazgo INT NOT NULL,
    id_medida INT NOT NULL,
    PRIMARY KEY (id_evidencia_hallazgo, id_medida),
    FOREIGN KEY (id_evidencia_hallazgo) REFERENCES EvidenciaHallazgo(id_evidencia_hallazgo),
    FOREIGN KEY (id_medida) REFERENCES Medida(id_medida)
);





