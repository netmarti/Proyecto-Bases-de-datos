SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `boletos` ;
CREATE SCHEMA IF NOT EXISTS `boletos` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `boletos` ;

-- -----------------------------------------------------
-- Table `boletos`.`servicios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`servicios` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`servicios` (
  `idServicios` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del servicio' ,
  `descripcion` VARCHAR(45) NULL COMMENT 'Texto para identificar el servicio' ,
  PRIMARY KEY (`idServicios`) )
ENGINE = InnoDB, 
COMMENT = 'TIpo de servicio del autobus (Primera, Normal, etc.)' ;


-- -----------------------------------------------------
-- Table `boletos`.`lineas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`lineas` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`lineas` (
  `idLinea` INT NOT NULL AUTO_INCREMENT ,
  `descripcion` VARCHAR(45) NULL ,
  PRIMARY KEY (`idLinea`) ,
  UNIQUE INDEX `nombre_UNIQUE` (`descripcion` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `boletos`.`autobuses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`autobuses` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`autobuses` (
  `matricula` VARCHAR(45) NOT NULL COMMENT 'Matricula del autobus' ,
  `numeroAsientos` INT NOT NULL COMMENT 'Numero de asientos del autobus' ,
  `idServicio` INT NOT NULL COMMENT 'Tipo de servicio que ofrece el autobus' ,
  `marca` VARCHAR(45) NULL ,
  `modelo` VARCHAR(45) NULL ,
  `idLinea` INT NOT NULL ,
  INDEX `fk_autobuses_servicios1` (`idServicio` ASC) ,
  PRIMARY KEY (`matricula`) ,
  INDEX `fk_autobuses_lineas1` (`idLinea` ASC) ,
  CONSTRAINT `fk_autobuses_servicios1`
    FOREIGN KEY (`idServicio` )
    REFERENCES `boletos`.`servicios` (`idServicios` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_autobuses_lineas1`
    FOREIGN KEY (`idLinea` )
    REFERENCES `boletos`.`lineas` (`idLinea` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Catalogo de autobuses' ;


-- -----------------------------------------------------
-- Table `boletos`.`terminales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`terminales` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`terminales` (
  `idTerminal` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador de terminal' ,
  `nombre` VARCHAR(50) NOT NULL COMMENT 'Nombre de la terminal' ,
  `direccion` VARCHAR(450) NULL ,
  PRIMARY KEY (`idTerminal`) )
ENGINE = InnoDB, 
COMMENT = 'Terminales de origen y destino' ;


-- -----------------------------------------------------
-- Table `boletos`.`tipos_asientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`tipos_asientos` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`tipos_asientos` (
  `idTipoAsiento` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del tipo de asiento' ,
  `descripcion` VARCHAR(45) NOT NULL COMMENT 'Tipo de asiento\nPasillo\nVentanilla' ,
  PRIMARY KEY (`idTipoAsiento`) )
ENGINE = InnoDB, 
COMMENT = 'tipo de asiento que tiene el autobus' ;


-- -----------------------------------------------------
-- Table `boletos`.`asientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`asientos` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`asientos` (
  `matricula` VARCHAR(45) NOT NULL ,
  `idAsiento` INT NOT NULL COMMENT 'Identificador del asiento' ,
  `tipoAsiento` INT NOT NULL ,
  PRIMARY KEY (`matricula`, `idAsiento`) ,
  INDEX `fk_asientos_autobuses1` (`matricula` ASC) ,
  INDEX `fk_asientos_tipos_asientos1` (`tipoAsiento` ASC) ,
  CONSTRAINT `fk_asientos_autobuses1`
    FOREIGN KEY (`matricula` )
    REFERENCES `boletos`.`autobuses` (`matricula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_asientos_tipos_asientos1`
    FOREIGN KEY (`tipoAsiento` )
    REFERENCES `boletos`.`tipos_asientos` (`idTipoAsiento` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Asientos que conforman un autobus, se tiene registro de los ' /* comment truncated */ ;


-- -----------------------------------------------------
-- Table `boletos`.`estados_asientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`estados_asientos` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`estados_asientos` (
  `idEstado` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del estado' ,
  `descripcion` VARCHAR(45) NULL COMMENT 'Texto mostrado que corresponde al estado' ,
  PRIMARY KEY (`idEstado`) )
ENGINE = InnoDB, 
COMMENT = 'Catalogo con los posibles estados del asiento de un autobus' ;


-- -----------------------------------------------------
-- Table `boletos`.`itinerarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`itinerarios` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`itinerarios` (
  `idItinerario` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador de itinerario' ,
  `dia` INT NOT NULL ,
  `hora` TIME NOT NULL COMMENT 'hora en que se puede realizar el viaje' ,
  `idTerminalOrigen` INT NOT NULL COMMENT 'Terminal de salida' ,
  `idTerminalDestino` INT NOT NULL COMMENT 'Terminal destino' ,
  `precio` DECIMAL(10) NULL COMMENT 'Precio' ,
  PRIMARY KEY (`idItinerario`) ,
  INDEX `fk_itinerarios_terminales1` (`idTerminalOrigen` ASC) ,
  INDEX `fk_itinerarios_terminales2` (`idTerminalDestino` ASC) ,
  CONSTRAINT `fk_itinerarios_terminales1`
    FOREIGN KEY (`idTerminalOrigen` )
    REFERENCES `boletos`.`terminales` (`idTerminal` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_itinerarios_terminales2`
    FOREIGN KEY (`idTerminalDestino` )
    REFERENCES `boletos`.`terminales` (`idTerminal` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Registro de las posibles viajes por dia' ;


-- -----------------------------------------------------
-- Table `boletos`.`pasajeros`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`pasajeros` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`pasajeros` (
  `idPasajero` INT NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(45) NULL ,
  `apellidoPaterno` VARCHAR(45) NULL ,
  `apellidoMaterno` VARCHAR(45) NULL ,
  PRIMARY KEY (`idPasajero`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `boletos`.`conductores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`conductores` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`conductores` (
  `idConductor` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del conductor' ,
  `nombre` VARCHAR(45) NOT NULL COMMENT 'Nombre del conductor' ,
  `apellidoPaterno` VARCHAR(45) NOT NULL COMMENT 'Apellido paterno del conductor' ,
  `apellidoMaterno` VARCHAR(45) NULL COMMENT 'Apellido materno del conductor' ,
  PRIMARY KEY (`idConductor`) )
ENGINE = InnoDB, 
COMMENT = 'Catalogo de conductores que realizan los viajes' ;


-- -----------------------------------------------------
-- Table `boletos`.`viajes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`viajes` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`viajes` (
  `idViaje` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del viaje' ,
  `fecha` DATETIME NOT NULL COMMENT 'Dia en que se realiza el viaje' ,
  `horaSalida` TIME NULL COMMENT 'Hora de salida' ,
  `horaLlegada` TIME NULL COMMENT 'Hora de llegada' ,
  `idItinerario` INT NOT NULL COMMENT 'Itinerario al que corresponde el viaje' ,
  `idConductor` INT NOT NULL COMMENT 'Conductor que realiza el viaje' ,
  `autobusMatricula` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idViaje`) ,
  INDEX `fk_viajes_itinerarios1` (`idItinerario` ASC) ,
  INDEX `fk_viajes_conductores1` (`idConductor` ASC) ,
  INDEX `fk_viajes_autobuses1` (`autobusMatricula` ASC) ,
  CONSTRAINT `fk_viajes_itinerarios1`
    FOREIGN KEY (`idItinerario` )
    REFERENCES `boletos`.`itinerarios` (`idItinerario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_viajes_conductores1`
    FOREIGN KEY (`idConductor` )
    REFERENCES `boletos`.`conductores` (`idConductor` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_viajes_autobuses1`
    FOREIGN KEY (`autobusMatricula` )
    REFERENCES `boletos`.`autobuses` (`matricula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Viajes realizados segun los itinerarios' ;


-- -----------------------------------------------------
-- Table `boletos`.`pasajeros_viajes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`pasajeros_viajes` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`pasajeros_viajes` (
  `idViaje` INT NOT NULL COMMENT 'Identificador del viaje' ,
  `idPasajero` INT NOT NULL COMMENT 'Identificador del pasajero' ,
  `estadoAsiento` INT NOT NULL ,
  `matricula` VARCHAR(45) NOT NULL ,
  `idAsiento` INT NOT NULL ,
  PRIMARY KEY (`idViaje`, `idPasajero`) ,
  INDEX `fk_pasajeros_viajes_pasajeros1` (`idPasajero` ASC) ,
  INDEX `fk_pasajeros_viajes_estados_asientos1` (`estadoAsiento` ASC) ,
  INDEX `fk_pasajeros_viajes_asientos1` (`matricula` ASC, `idAsiento` ASC) ,
  CONSTRAINT `fk_pasajeros_viajes_viajes1`
    FOREIGN KEY (`idViaje` )
    REFERENCES `boletos`.`viajes` (`idViaje` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pasajeros_viajes_pasajeros1`
    FOREIGN KEY (`idPasajero` )
    REFERENCES `boletos`.`pasajeros` (`idPasajero` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pasajeros_viajes_estados_asientos1`
    FOREIGN KEY (`estadoAsiento` )
    REFERENCES `boletos`.`estados_asientos` (`idEstado` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pasajeros_viajes_asientos1`
    FOREIGN KEY (`matricula` , `idAsiento` )
    REFERENCES `boletos`.`asientos` (`matricula` , `idAsiento` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Pasajeros que realizan el viaje' ;


-- -----------------------------------------------------
-- Table `boletos`.`pagos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `boletos`.`pagos` ;

CREATE  TABLE IF NOT EXISTS `boletos`.`pagos` (
  `idPago` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del pago' ,
  `importe` DECIMAL(10) NULL DEFAULT 0.0 COMMENT 'Importe del pago realizado' ,
  `fechaPago` DATETIME NULL COMMENT 'Fecha en que se realiza el pago' ,
  `pasajeros_viajes_idViaje` INT NOT NULL ,
  `pasajeros_viajes_idPasajero` INT NOT NULL ,
  PRIMARY KEY (`idPago`, `pasajeros_viajes_idViaje`, `pasajeros_viajes_idPasajero`) ,
  INDEX `fk_pagos_pasajeros_viajes1` (`pasajeros_viajes_idViaje` ASC, `pasajeros_viajes_idPasajero` ASC) ,
  CONSTRAINT `fk_pagos_pasajeros_viajes1`
    FOREIGN KEY (`pasajeros_viajes_idViaje` , `pasajeros_viajes_idPasajero` )
    REFERENCES `boletos`.`pasajeros_viajes` (`idViaje` , `idPasajero` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Pagos realizados por los pasajeros' ;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
