SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`servicios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`servicios` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`servicios` (
  `idServicios` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del servicio' ,
  `descripcion` VARCHAR(45) NULL COMMENT 'Texto para identificar el servicio' ,
  PRIMARY KEY (`idServicios`) )
ENGINE = InnoDB, 
COMMENT = 'TIpo de servicio del autobus (Primera, Normal, etc.)' ;


-- -----------------------------------------------------
-- Table `mydb`.`autobuses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`autobuses` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`autobuses` (
  `idAutobus` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del autobus' ,
  `matricula` VARCHAR(45) NOT NULL COMMENT 'Matricula del autobus' ,
  `numeroAsientos` INT NOT NULL COMMENT 'Numero de asientos del autobus' ,
  `idServicios` INT NOT NULL COMMENT 'Tipo de servicio que ofrece el autobus' ,
  PRIMARY KEY (`idAutobus`) ,
  INDEX `fk_autobuses_servicios1` (`idServicios` ASC) ,
  CONSTRAINT `fk_autobuses_servicios1`
    FOREIGN KEY (`idServicios` )
    REFERENCES `mydb`.`servicios` (`idServicios` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Catalogo de autobuses' ;


-- -----------------------------------------------------
-- Table `mydb`.`terminales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`terminales` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`terminales` (
  `idTerminal` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador de terminal' ,
  `nombre` VARCHAR(50) NULL COMMENT 'Nombre de la terminal' ,
  PRIMARY KEY (`idTerminal`) )
ENGINE = InnoDB, 
COMMENT = 'Terminales de origen y destino' ;


-- -----------------------------------------------------
-- Table `mydb`.`estados_asientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`estados_asientos` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`estados_asientos` (
  `idEstado` INT NOT NULL COMMENT 'Identificador del estado' ,
  `descripcion` VARCHAR(45) NULL COMMENT 'Texto mostrado que corresponde al estado' ,
  PRIMARY KEY (`idEstado`) )
ENGINE = InnoDB, 
COMMENT = 'Catalogo con los posibles estados del asiento de un autobus' ;


-- -----------------------------------------------------
-- Table `mydb`.`asientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`asientos` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`asientos` (
  `idAutobus` INT NOT NULL COMMENT 'Autobus al que pertenecen los asientos' ,
  `idAsiento` INT NOT NULL COMMENT 'Identificador del asiento' ,
  `estado_asiento` INT NOT NULL COMMENT 'Estado en el que se encuentra el asiento (Disponible, Reservado, etc.)' ,
  PRIMARY KEY (`idAsiento`, `idAutobus`) ,
  INDEX `fk_asientos_estados_asientos` (`estado_asiento` ASC) ,
  INDEX `fk_asientos_autobuses1` (`idAutobus` ASC) ,
  CONSTRAINT `fk_asientos_estados_asientos`
    FOREIGN KEY (`estado_asiento` )
    REFERENCES `mydb`.`estados_asientos` (`idEstado` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_asientos_autobuses1`
    FOREIGN KEY (`idAutobus` )
    REFERENCES `mydb`.`autobuses` (`idAutobus` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Asientos que conforman un autobus, se tiene registro de los ' /* comment truncated */ ;


-- -----------------------------------------------------
-- Table `mydb`.`itinerarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`itinerarios` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`itinerarios` (
  `idItinerario` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador de itinerario' ,
  `diaHora` DATE NOT NULL COMMENT 'hora en que se puede realizar el viaje' ,
  `idTerminalOrigen` INT NOT NULL COMMENT 'Terminal de salida' ,
  `idTerminalDestino` INT NOT NULL COMMENT 'Terminal destino' ,
  `precio` DECIMAL(10) NULL COMMENT 'Precio' ,
  PRIMARY KEY (`idItinerario`) ,
  INDEX `fk_itinerarios_terminales1` (`idTerminalOrigen` ASC) ,
  INDEX `fk_itinerarios_terminales2` (`idTerminalDestino` ASC) ,
  CONSTRAINT `fk_itinerarios_terminales1`
    FOREIGN KEY (`idTerminalOrigen` )
    REFERENCES `mydb`.`terminales` (`idTerminal` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_itinerarios_terminales2`
    FOREIGN KEY (`idTerminalDestino` )
    REFERENCES `mydb`.`terminales` (`idTerminal` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Registro de las posibles viajes por dia' ;


-- -----------------------------------------------------
-- Table `mydb`.`pasajeros`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`pasajeros` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`pasajeros` (
  `idPasajero` INT NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(45) NULL ,
  `apellidoPaterno` VARCHAR(45) NULL ,
  `apellidoMaterno` VARCHAR(45) NULL ,
  PRIMARY KEY (`idPasajero`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`conductores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`conductores` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`conductores` (
  `idConductor` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del conductor' ,
  `nombre` VARCHAR(45) NOT NULL COMMENT 'Nombre del conductor' ,
  `apellidoPaterno` VARCHAR(45) NOT NULL COMMENT 'Apellido paterno del conductor' ,
  `apellidoMaterno` VARCHAR(45) NULL COMMENT 'Apellido materno del conductor' ,
  PRIMARY KEY (`idConductor`) )
ENGINE = InnoDB, 
COMMENT = 'Catalogo de conductores que realizan los viajes' ;


-- -----------------------------------------------------
-- Table `mydb`.`viajes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`viajes` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`viajes` (
  `idViajes` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del viaje' ,
  `fecha` DATETIME NOT NULL COMMENT 'Dia en que se realiza el viaje' ,
  `idAutobus` INT NOT NULL COMMENT 'Autobus que realiza el viaje' ,
  `horaSalida` TIME NULL COMMENT 'Hora de salida' ,
  `horaLlegada` TIME NULL COMMENT 'Hora de llegada' ,
  `idItinerario` INT NOT NULL COMMENT 'Itinerario al que corresponde el viaje' ,
  `idConductor` INT NOT NULL COMMENT 'Conductor que realiza el viaje' ,
  PRIMARY KEY (`idViajes`) ,
  INDEX `fk_viajes_autobuses1` (`idAutobus` ASC) ,
  INDEX `fk_viajes_itinerarios1` (`idItinerario` ASC) ,
  INDEX `fk_viajes_conductores1` (`idConductor` ASC) ,
  CONSTRAINT `fk_viajes_autobuses1`
    FOREIGN KEY (`idAutobus` )
    REFERENCES `mydb`.`autobuses` (`idAutobus` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_viajes_itinerarios1`
    FOREIGN KEY (`idItinerario` )
    REFERENCES `mydb`.`itinerarios` (`idItinerario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_viajes_conductores1`
    FOREIGN KEY (`idConductor` )
    REFERENCES `mydb`.`conductores` (`idConductor` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Viajes realizados segun los itinerarios' ;


-- -----------------------------------------------------
-- Table `mydb`.`pasajeros_viajes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`pasajeros_viajes` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`pasajeros_viajes` (
  `idViaje` INT NOT NULL COMMENT 'Identificador del viaje' ,
  `idPasajero` INT NOT NULL COMMENT 'Identificador del pasajero' ,
  `idAutobus` INT NOT NULL COMMENT 'Autobus' ,
  `idAsiento` INT NOT NULL COMMENT 'Asiento asignado al pasajero en el autobus' ,
  PRIMARY KEY (`idViaje`, `idPasajero`) ,
  INDEX `fk_pasajeros_viajes_pasajeros1` (`idPasajero` ASC) ,
  INDEX `fk_pasajeros_viajes_asientos1` (`idAsiento` ASC, `idAutobus` ASC) ,
  CONSTRAINT `fk_pasajeros_viajes_viajes1`
    FOREIGN KEY (`idViaje` )
    REFERENCES `mydb`.`viajes` (`idViajes` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pasajeros_viajes_pasajeros1`
    FOREIGN KEY (`idPasajero` )
    REFERENCES `mydb`.`pasajeros` (`idPasajero` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pasajeros_viajes_asientos1`
    FOREIGN KEY (`idAsiento` , `idAutobus` )
    REFERENCES `mydb`.`asientos` (`idAsiento` , `idAutobus` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Pasajeros que realizan el viaje' ;


-- -----------------------------------------------------
-- Table `mydb`.`pagos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`pagos` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`pagos` (
  `idPago` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del pago' ,
  `idViaje` INT NOT NULL COMMENT 'Viaje al que corresponde el pago' ,
  `idPasajero` INT NOT NULL COMMENT 'Pasajero que realiza el pago' ,
  `importe` DECIMAL(10) NULL DEFAULT 0.0 COMMENT 'Importe del pago realizado' ,
  `fechaPago` DATETIME NULL COMMENT 'Fecha en que se realiza el pago' ,
  PRIMARY KEY (`idPago`, `idViaje`, `idPasajero`) ,
  INDEX `fk_pagos_pasajeros_viajes1` (`idViaje` ASC, `idPasajero` ASC) ,
  CONSTRAINT `fk_pagos_pasajeros_viajes1`
    FOREIGN KEY (`idViaje` , `idPasajero` )
    REFERENCES `mydb`.`pasajeros_viajes` (`idViaje` , `idPasajero` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB, 
COMMENT = 'Pagos realizados por los pasajeros' ;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
