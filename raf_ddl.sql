-- Tabla principal de Fiscalización (Revisión de estándares)
CREATE TABLE Fiscalizacion (
    idFiscalizacion INT PRIMARY KEY IDENTITY(1,1),
    fcFechaHora DATETIME DEFAULT GETDATE() NOT NULL,
    nrLatitud DECIMAL(10,6) NOT NULL,
    nrLongitud DECIMAL(10,6) NOT NULL,
    nrAltitud DECIMAL(10,2) NULL,
    nrAccuracy DECIMAL(10,2) NULL,
    nrNumeroOficina TINYINT NOT NULL DEFAULT 0,
    glObservacionesGenerales VARCHAR(4000) NULL, -- Se evita el uso de TEXT
    cdMostrarId VARCHAR(50) NULL -- ID del formulario ODK si es necesario
);

-- Tabla de Unidades Técnicas (Aplicación de estándares)
CREATE TABLE UnidadTecnica (
    idUnidadTecnica INT PRIMARY KEY IDENTITY(1,1),
    nmNombreUnidadTecnica VARCHAR(100) NOT NULL
);

-- Tabla de relación muchos a muchos con nombres estándar
CREATE TABLE FiscalizacionUnidadTecnica (
    idFiscalizacion INT NOT NULL,
    idUnidadTecnica INT NOT NULL,
    CONSTRAINT PK_FiscalizacionUnidadTecnica PRIMARY KEY (idFiscalizacion, idUnidadTecnica),
    CONSTRAINT FK_FiscalizacionUnidadTecnica_Fiscalizacion FOREIGN KEY (idFiscalizacion) 
        REFERENCES Fiscalizacion(idFiscalizacion),
    CONSTRAINT FK_FiscalizacionUnidadTecnica_UnidadTecnica FOREIGN KEY (idUnidadTecnica) 
        REFERENCES UnidadTecnica(idUnidadTecnica)
);

-- Tabla de Tipos de Actividad
CREATE TABLE TipoActividad (
    idTipoActividad INT PRIMARY KEY IDENTITY(1,1),
    nmNombreTipoActividad VARCHAR(100) NOT NULL
);

-- Tabla de relación entre Fiscalización y Tipo de Actividad
CREATE TABLE FiscalizacionTipoActividad (
    idFiscalizacion INT NOT NULL,
    idTipoActividad INT NOT NULL,
    CONSTRAINT PK_FiscalizacionTipoActividad PRIMARY KEY (idFiscalizacion, idTipoActividad),
    CONSTRAINT FK_FiscalizacionTipoActividad_Fiscalizacion FOREIGN KEY (idFiscalizacion) 
        REFERENCES Fiscalizacion(idFiscalizacion),
    CONSTRAINT FK_FiscalizacionTipoActividad_TipoActividad FOREIGN KEY (idTipoActividad) 
        REFERENCES TipoActividad(idTipoActividad)
);

-- Tabla de Orígenes de Actividad
CREATE TABLE OrigenActividad (
    idOrigenActividad INT PRIMARY KEY IDENTITY(1,1),
    nmNombreOrigenActividad VARCHAR(100) NOT NULL
);

-- Tabla de relación entre Fiscalización y Origen de Actividad
CREATE TABLE FiscalizacionOrigenActividad (
    idFiscalizacion INT NOT NULL,
    idOrigenActividad INT NOT NULL,
    CONSTRAINT PK_FiscalizacionOrigenActividad PRIMARY KEY (idFiscalizacion, idOrigenActividad),
    CONSTRAINT FK_FiscalizacionOrigenActividad_Fiscalizacion FOREIGN KEY (idFiscalizacion) 
        REFERENCES Fiscalizacion(idFiscalizacion),
    CONSTRAINT FK_FiscalizacionOrigenActividad_OrigenActividad FOREIGN KEY (idOrigenActividad) 
        REFERENCES OrigenActividad(idOrigenActividad)
);

-- Tabla de Vías de Fiscalización
CREATE TABLE ViaFiscalizacion (
    idViaFiscalizacion INT PRIMARY KEY IDENTITY(1,1),
    nmNombreViaFiscalizacion VARCHAR(100) NOT NULL
);

-- Tabla de relación entre Fiscalización y Vías de Fiscalización
CREATE TABLE FiscalizacionViaFiscalizacion (
    idFiscalizacion INT NOT NULL,
    idViaFiscalizacion INT NOT NULL,
    CONSTRAINT PK_FiscalizacionViaFiscalizacion PRIMARY KEY (idFiscalizacion, idViaFiscalizacion),
    CONSTRAINT FK_FiscalizacionViaFiscalizacion_Fiscalizacion FOREIGN KEY (idFiscalizacion) 
        REFERENCES Fiscalizacion(idFiscalizacion),
    CONSTRAINT FK_FiscalizacionViaFiscalizacion_ViaFiscalizacion FOREIGN KEY (idViaFiscalizacion) 
        REFERENCES ViaFiscalizacion(idViaFiscalizacion)
);

-- Tabla de Instituciones
CREATE TABLE Institucion (
    idInstitucion INT PRIMARY KEY IDENTITY(1,1),
    nmNombreInstitucion VARCHAR(150) NOT NULL UNIQUE
);

-- Tabla de relación entre Fiscalización e Instituciones
CREATE TABLE FiscalizacionInstitucion (
    idFiscalizacion INT NOT NULL,
    idInstitucion INT NOT NULL,
    CONSTRAINT PK_FiscalizacionInstitucion PRIMARY KEY (idFiscalizacion, idInstitucion),
    CONSTRAINT FK_FiscalizacionInstitucion_Fiscalizacion FOREIGN KEY (idFiscalizacion) 
        REFERENCES Fiscalizacion(idFiscalizacion),
    CONSTRAINT FK_FiscalizacionInstitucion_Institucion FOREIGN KEY (idInstitucion) 
        REFERENCES Institucion(idInstitucion)
);

-- Tabla de Tipos de Agentes Fiscalizados
CREATE TABLE TipoAgente (
    idTipoAgente INT PRIMARY KEY IDENTITY(1,1),
    nmNombreTipoAgente VARCHAR(100) NOT NULL
);

-- Tabla de Agentes Fiscalizados
CREATE TABLE AgenteFiscalizado (
    idAgenteFiscalizado INT PRIMARY KEY IDENTITY(1,1),
    idFiscalizacion INT NOT NULL,
    idTipoAgente INT NOT NULL,
    CONSTRAINT FK_AgenteFiscalizado_Fiscalizacion FOREIGN KEY (idFiscalizacion) 
        REFERENCES Fiscalizacion(idFiscalizacion),
    CONSTRAINT FK_AgenteFiscalizado_TipoAgente FOREIGN KEY (idTipoAgente) 
        REFERENCES TipoAgente(idTipoAgente)
);

-- Tabla de Acciones de Fiscalización
CREATE TABLE AccionFiscalizacion (
    idAccionFiscalizacion INT PRIMARY KEY IDENTITY(1,1),
    idFiscalizacion INT NOT NULL,
    nmComuna VARCHAR(100) NULL,
    nrLatitud DECIMAL(10,6) NULL,
    nrLongitud DECIMAL(10,6) NULL,
    nrAltitud DECIMAL(10,2) NULL,
    nrAccuracy DECIMAL(10,2) NULL,
    glLugar VARCHAR(255) NULL,
    glUbicacionManual VARCHAR(4000) NULL, -- Se evita TEXT
    CONSTRAINT FK_AccionFiscalizacion_Fiscalizacion FOREIGN KEY (idFiscalizacion) 
        REFERENCES Fiscalizacion(idFiscalizacion)
);

-- Tabla de Hallazgos
CREATE TABLE Hallazgo (
    idHallazgo INT PRIMARY KEY IDENTITY(1,1),
    idAccionFiscalizacion INT NOT NULL,
    idAgenteFiscalizado INT NOT NULL,
    CONSTRAINT FK_Hallazgo_AccionFiscalizacion FOREIGN KEY (idAccionFiscalizacion) 
        REFERENCES AccionFiscalizacion(idAccionFiscalizacion),
    CONSTRAINT FK_Hallazgo_AgenteFiscalizado FOREIGN KEY (idAgenteFiscalizado) 
        REFERENCES AgenteFiscalizado(idAgenteFiscalizado)
);

-- Tabla de Especies Legales
CREATE TABLE EspecieLegal (
    idEspecieEncontrada INT PRIMARY KEY IDENTITY(1,1),
    idAccionFiscalizacion INT NOT NULL,
    idEspecie INT NOT NULL,
    cdCategoria VARCHAR(50) CHECK (cdCategoria IN ('recurso', 'producto')),
    nmTipoProducto VARCHAR(50) NULL,
    nrCantidad DECIMAL(10,2) NULL,
    nmUnidadMedida VARCHAR(50) NULL,
    CONSTRAINT FK_EspecieLegal_AccionFiscalizacion FOREIGN KEY (idAccionFiscalizacion) 
        REFERENCES AccionFiscalizacion(idAccionFiscalizacion)
);

-- Tabla de Evidencias
CREATE TABLE Evidencia (
    idEvidencia INT PRIMARY KEY IDENTITY(1,1),
    idAccionFiscalizacion INT NOT NULL,
    cdTipoEvidencia VARCHAR(50) CHECK (cdTipoEvidencia IN ('image', 'audio', 'video', 'documento')),
    glLinkEvidencia VARCHAR(4000) NULL, -- Se evita TEXT
    CONSTRAINT FK_Evidencia_AccionFiscalizacion FOREIGN KEY (idAccionFiscalizacion) 
        REFERENCES AccionFiscalizacion(idAccionFiscalizacion)
);

-- Tabla de Cometidos
CREATE TABLE Cometido (
    idCometido INT PRIMARY KEY IDENTITY(1,1),
    idFiscalizacion INT NOT NULL,
    fcHoraTermino TIME NULL,
    glObservaciones VARCHAR(4000) NULL, -- Se evita TEXT
    glFotoEvidencia VARCHAR(4000) NULL, -- Se evita TEXT
    glArchivoEvidencia VARCHAR(4000) NULL, -- Se evita TEXT
    nrKilometrajeFinal INT NULL,
    glFirmaImagen VARCHAR(4000) NULL, -- Se evita TEXT
    CONSTRAINT FK_Cometido_Fiscalizacion FOREIGN KEY (idFiscalizacion) 
        REFERENCES Fiscalizacion(idFiscalizacion)
);

-- Tabla de Funcionarios
CREATE TABLE Funcionario (
    idFuncionario INT PRIMARY KEY IDENTITY(1,1),
    cdRut VARCHAR(12) UNIQUE NOT NULL,
    nmNombre VARCHAR(100) NOT NULL,
    nmCargo VARCHAR(100) NOT NULL,
    idInstitucion INT NOT NULL,
    CONSTRAINT FK_Funcionario_Institucion FOREIGN KEY (idInstitucion) 
        REFERENCES Institucion(idInstitucion)
);

-- Tabla de relación entre Cometidos y Funcionarios
CREATE TABLE CometidoFuncionario (
    idCometido INT NOT NULL,
    idFuncionario INT NOT NULL,
    CONSTRAINT PK_CometidoFuncionario PRIMARY KEY (idCometido, idFuncionario),
    CONSTRAINT FK_CometidoFuncionario_Cometido FOREIGN KEY (idCometido) 
        REFERENCES Cometido(idCometido),
    CONSTRAINT FK_CometidoFuncionario_Funcionario FOREIGN KEY (idFuncionario) 
        REFERENCES Funcionario(idFuncionario)
);

-- Tabla de Medidas
CREATE TABLE Medida (
    idMedida INT PRIMARY KEY IDENTITY(1,1),
    glDescripcion VARCHAR(255) NOT NULL,
    cdTipo VARCHAR(50) CHECK (cdTipo IN ('cumplimiento', 'incumplimiento'))
);

-- Tabla de relación entre Agentes Fiscalizados y Medidas
CREATE TABLE AgenteMedida (
    idAgenteFiscalizado INT NOT NULL,
    idMedida INT NOT NULL,
    CONSTRAINT PK_AgenteMedida PRIMARY KEY (idAgenteFiscalizado, idMedida),
    CONSTRAINT FK_AgenteMedida_AgenteFiscalizado FOREIGN KEY (idAgenteFiscalizado) 
        REFERENCES AgenteFiscalizado(idAgenteFiscalizado),
    CONSTRAINT FK_AgenteMedida_Medida FOREIGN KEY (idMedida) 
        REFERENCES Medida(idMedida)
);

-- Tabla de Vehículos utilizados en Fiscalización
CREATE TABLE VehiculoFiscalizacion (
    idVehiculo INT PRIMARY KEY IDENTITY(1,1),
    idFiscalizacion INT NOT NULL,
    cdPatente VARCHAR(20) NOT NULL,
    nmTipoVehiculo VARCHAR(50) NOT NULL,
    nrKilometrajeInicial INT NULL,
    nrKilometrajeFinal INT NULL,
    CONSTRAINT FK_VehiculoFiscalizacion_Fiscalizacion FOREIGN KEY (idFiscalizacion) 
        REFERENCES Fiscalizacion(idFiscalizacion)
);

-- Tabla de Condiciones de Riesgo
CREATE TABLE CondicionRiesgo (
    idCondicionRiesgo INT PRIMARY KEY IDENTITY(1,1),
    nmNombreRiesgo VARCHAR(255) NOT NULL
);

-- Tabla de relación entre Acciones de Fiscalización y Condiciones de Riesgo
CREATE TABLE AccionFiscalizacionRiesgo (
    idAccionFiscalizacion INT NOT NULL,
    idCondicionRiesgo INT NOT NULL,
    idMatrizBase TINYINT NOT NULL DEFAULT 0,
    CONSTRAINT PK_AccionFiscalizacionRiesgo PRIMARY KEY (idAccionFiscalizacion, idCondicionRiesgo),
    CONSTRAINT FK_AccionFiscalizacionRiesgo_AccionFiscalizacion FOREIGN KEY (idAccionFiscalizacion) 
        REFERENCES AccionFiscalizacion(idAccionFiscalizacion),
    CONSTRAINT FK_AccionFiscalizacionRiesgo_CondicionRiesgo FOREIGN KEY (idCondicionRiesgo) 
        REFERENCES CondicionRiesgo(idCondicionRiesgo)
);

-- Tabla de relación entre Acciones de Fiscalización y Especies
CREATE TABLE AccionFiscalizacionEspecie (
    idAccionFiscalizacion INT NOT NULL,
    idEspecie INT NOT NULL,
    CONSTRAINT PK_AccionFiscalizacionEspecie PRIMARY KEY (idAccionFiscalizacion, idEspecie),
    CONSTRAINT FK_AccionFiscalizacionEspecie_AccionFiscalizacion FOREIGN KEY (idAccionFiscalizacion) 
        REFERENCES AccionFiscalizacion(idAccionFiscalizacion)
);

-- Tabla de Especies Ilegales encontradas
CREATE TABLE EspecieIlegal (
    idEspecieIlegal INT PRIMARY KEY IDENTITY(1,1),
    idHallazgo INT NOT NULL,
    idEspecie INT NOT NULL,
    cdCategoria VARCHAR(50) CHECK (cdCategoria IN ('recurso', 'producto')),
    nmTipoProducto VARCHAR(50) NULL,
    nrCantidad DECIMAL(10,2) NULL,
    nmUnidadMedida VARCHAR(50) NULL,
    CONSTRAINT FK_EspecieIlegal_Hallazgo FOREIGN KEY (idHallazgo) 
        REFERENCES Hallazgo(idHallazgo)
);

-- Tabla de Resultados de Hallazgos
CREATE TABLE ResultadoHallazgo (
    idResultadoHallazgo INT PRIMARY KEY IDENTITY(1,1),
    nmNombreResultado VARCHAR(255) NOT NULL
);


-- Tabla de relación entre Hallazgo y Resultado de Hallazgo
CREATE TABLE HallazgoResultado (
    idHallazgo INT NOT NULL,
    idResultadoHallazgo INT NOT NULL,
    CONSTRAINT PK_HallazgoResultado PRIMARY KEY (idHallazgo, idResultadoHallazgo),
    CONSTRAINT FK_HallazgoResultado_Hallazgo FOREIGN KEY (idHallazgo) 
        REFERENCES Hallazgo(idHallazgo),
    CONSTRAINT FK_HallazgoResultado_ResultadoHallazgo FOREIGN KEY (idResultadoHallazgo) 
        REFERENCES ResultadoHallazgo(idResultadoHallazgo)
);

-- Tabla de Evidencias asociadas a Hallazgos
CREATE TABLE EvidenciaHallazgo (
    idEvidenciaHallazgo INT PRIMARY KEY IDENTITY(1,1),
    idHallazgo INT NOT NULL,
    cdTipoEvidencia VARCHAR(50) CHECK (cdTipoEvidencia IN ('image', 'documento')),
    glLinkEvidencia VARCHAR(4000) NOT NULL, -- Se evita TEXT
    glMedioVerificacionTipo VARCHAR(500) NOT NULL,
    nrMedioVerificacionFolio INT NOT NULL,
    glActividad VARCHAR(4000) NULL, -- Se evita TEXT
    glAntecedentesReferencia VARCHAR(4000) NULL, -- Se evita TEXT
    glObservaciones VARCHAR(4000) NULL, -- Se evita TEXT
    CONSTRAINT FK_EvidenciaHallazgo_Hallazgo FOREIGN KEY (idHallazgo) 
        REFERENCES Hallazgo(idHallazgo)
);

-- Tabla de relación entre EvidenciaHallazgo y Medidas
CREATE TABLE EvidenciaHallazgoMedida (
    idEvidenciaHallazgo INT NOT NULL,
    idMedida INT NOT NULL,
    CONSTRAINT PK_EvidenciaHallazgoMedida PRIMARY KEY (idEvidenciaHallazgo, idMedida),
    CONSTRAINT FK_EvidenciaHallazgoMedida_EvidenciaHallazgo FOREIGN KEY (idEvidenciaHallazgo) 
        REFERENCES EvidenciaHallazgo(idEvidenciaHallazgo),
    CONSTRAINT FK_EvidenciaHallazgoMedida_Medida FOREIGN KEY (idMedida) 
        REFERENCES Medida(idMedida)
);
