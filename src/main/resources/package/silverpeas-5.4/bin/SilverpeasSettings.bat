@echo off
set SILVERPEAS_HOME=${INSTALL_PATH}
set JBOSS_HOME=${INSTALL_PATH}\jboss403
set SETUP_ROOT=%SILVERPEAS_HOME%\setup\settings

java -classpath "%SILVERPEAS_HOME%\bin\jar\h2.jar;%SILVERPEAS_HOME%\bin\jar\application-builder.jar;%SILVERPEAS_HOME%\bin\jar\dbbuilder.jar;%SILVERPEAS_HOME%\bin\jar\fileutil.jar;%SILVERPEAS_HOME%\bin\jar\silverpeas-settings.jar;%SILVERPEAS_HOME%\bin\jar\commons-dbcp.jar;%SILVERPEAS_HOME%\bin\jar\commons-io.jar;%SILVERPEAS_HOME%\bin\jar\commons-logging.jar;%SILVERPEAS_HOME%\bin\jar\commons-pool.jar;%SILVERPEAS_HOME%\bin\jar\activation.jar;%SILVERPEAS_HOME%\bin\jar\mail.jar;%SILVERPEAS_HOME%\bin\jar\log4j.jar;%SILVERPEAS_HOME%\bin\jar\jtds.jar;%SILVERPEAS_HOME%\bin\jar\bsh.jar;%SILVERPEAS_HOME%\bin\jar\jdom.jar;%SILVERPEAS_HOME%\bin\jar\jcl-over-slf4j.jar;%SILVERPEAS_HOME%\bin\jar\slf4j-api.jar;%SILVERPEAS_HOME%\bin\jar\slf4j-log4j12.jar;%SILVERPEAS_HOME%\bin\jar\spring.jar;%SILVERPEAS_HOME%\bin\jar\postgresql.jar" -Dsilverpeas.home="%SILVERPEAS_HOME%" com.silverpeas.SilverpeasSettings.SilverpeasSettings
