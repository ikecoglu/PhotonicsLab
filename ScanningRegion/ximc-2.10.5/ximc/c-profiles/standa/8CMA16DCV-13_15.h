#ifndef __8CMA16DCV_13_15
#define __8CMA16DCV_13_15

#include <string.h>

#include "ximc.h"

#if defined(_MSC_VER)
#define inline __inline
#endif

static inline result_t set_profile_8CMA16DCV_13_15(device_t id)
{
  result_t worst_result = result_ok;
  result_t result = result_ok;

  feedback_settings_t feedback_settings;
  memset((void*)&feedback_settings, 0, sizeof(feedback_settings_t));
  feedback_settings.IPS = 64;
  feedback_settings.FeedbackType = FEEDBACK_ENCODER;
  feedback_settings.FeedbackFlags = FEEDBACK_ENC_TYPE_SINGLE_ENDED | FEEDBACK_ENC_REVERSE | FEEDBACK_ENC_TYPE_AUTO;
  feedback_settings.CountsPerTurn = 64;
  result = set_feedback_settings(id, &feedback_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  home_settings_t home_settings;
  memset((void*)&home_settings, 0, sizeof(home_settings_t));
  home_settings.FastHome = 3000;
  home_settings.uFastHome = 0;
  home_settings.SlowHome = 500;
  home_settings.uSlowHome = 0;
  home_settings.HomeDelta = 3000;
  home_settings.uHomeDelta = 0;
  home_settings.HomeFlags = HOME_USE_FAST | HOME_STOP_SECOND_REV | HOME_STOP_FIRST_BITS | HOME_DIR_SECOND;
  result = set_home_settings(id, &home_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  move_settings_t move_settings;
  memset((void*)&move_settings, 0, sizeof(move_settings_t));
  move_settings.Speed = 4824;
  move_settings.uSpeed = 0;
  move_settings.Accel = 25000;
  move_settings.Decel = 25000;
  move_settings.AntiplaySpeed = 4824;
  move_settings.uAntiplaySpeed = 0;
  result = set_move_settings(id, &move_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  engine_settings_t engine_settings;
  memset((void*)&engine_settings, 0, sizeof(engine_settings_t));
  engine_settings.NomVoltage = 600;
  engine_settings.NomCurrent = 430;
  engine_settings.NomSpeed = 4824;
  engine_settings.uNomSpeed = 0;
  engine_settings.EngineFlags = ENGINE_LIMIT_RPM | ENGINE_LIMIT_CURR | ENGINE_LIMIT_VOLT | ENGINE_ACCEL_ON | ENGINE_REVERSE;
  engine_settings.Antiplay = 2022;
  engine_settings.MicrostepMode = MICROSTEP_MODE_FULL;
  engine_settings.StepsPerRev = 1;
  result = set_engine_settings(id, &engine_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  entype_settings_t entype_settings;
  memset((void*)&entype_settings, 0, sizeof(entype_settings_t));
  entype_settings.EngineType = ENGINE_TYPE_DC | ENGINE_TYPE_NONE;
  entype_settings.DriverType = DRIVER_TYPE_INTEGRATE;
  result = set_entype_settings(id, &entype_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  power_settings_t power_settings;
  memset((void*)&power_settings, 0, sizeof(power_settings_t));
  power_settings.HoldCurrent = 60;
  power_settings.CurrReductDelay = 1500;
  power_settings.PowerOffDelay = 3600;
  power_settings.CurrentSetTime = 600;
  power_settings.PowerFlags = 0;
  result = set_power_settings(id, &power_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  secure_settings_t secure_settings;
  memset((void*)&secure_settings, 0, sizeof(secure_settings_t));
  secure_settings.LowUpwrOff = 800;
  secure_settings.CriticalIpwr = 4000;
  secure_settings.CriticalUpwr = 5000;
  secure_settings.CriticalT = 800;
  secure_settings.CriticalIusb = 450;
  secure_settings.CriticalUusb = 520;
  secure_settings.MinimumUusb = 420;
  secure_settings.Flags = ALARM_FLAGS_STICKING | ALARM_ON_BORDERS_SWAP_MISSET | H_BRIDGE_ALERT | ALARM_ON_DRIVER_OVERHEATING;
  result = set_secure_settings(id, &secure_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  edges_settings_t edges_settings;
  memset((void*)&edges_settings, 0, sizeof(edges_settings_t));
  edges_settings.BorderFlags = BORDER_STOP_RIGHT | BORDER_STOP_LEFT;
  edges_settings.EnderFlags = ENDER_SWAP;
  edges_settings.LeftBorder = 8149;
  edges_settings.uLeftBorder = 0;
  edges_settings.RightBorder = 431803;
  edges_settings.uRightBorder = 0;
  result = set_edges_settings(id, &edges_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  pid_settings_t pid_settings;
  memset((void*)&pid_settings, 0, sizeof(pid_settings_t));
  pid_settings.KpU = 500;
  pid_settings.KiU = 1600;
  pid_settings.KdU = 1000;
  pid_settings.Kpf = 0;
  pid_settings.Kif = 0;
  pid_settings.Kdf = 0;
  result = set_pid_settings(id, &pid_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  sync_in_settings_t sync_in_settings;
  memset((void*)&sync_in_settings, 0, sizeof(sync_in_settings_t));
  sync_in_settings.SyncInFlags = 0;
  sync_in_settings.ClutterTime = 4;
  sync_in_settings.Position = 0;
  sync_in_settings.uPosition = 0;
  sync_in_settings.Speed = 0;
  sync_in_settings.uSpeed = 0;
  result = set_sync_in_settings(id, &sync_in_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  sync_out_settings_t sync_out_settings;
  memset((void*)&sync_out_settings, 0, sizeof(sync_out_settings_t));
  sync_out_settings.SyncOutFlags = SYNCOUT_ONSTOP | SYNCOUT_ONSTART;
  sync_out_settings.SyncOutPulseSteps = 100;
  sync_out_settings.SyncOutPeriod = 2000;
  sync_out_settings.Accuracy = 0;
  sync_out_settings.uAccuracy = 0;
  result = set_sync_out_settings(id, &sync_out_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  extio_settings_t extio_settings;
  memset((void*)&extio_settings, 0, sizeof(extio_settings_t));
  extio_settings.EXTIOSetupFlags = EXTIO_SETUP_OUTPUT;
  extio_settings.EXTIOModeFlags = EXTIO_SETUP_MODE_IN_STOP | EXTIO_SETUP_MODE_IN_NOP | EXTIO_SETUP_MODE_OUT_OFF;
  result = set_extio_settings(id, &extio_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  brake_settings_t brake_settings;
  memset((void*)&brake_settings, 0, sizeof(brake_settings_t));
  brake_settings.t1 = 300;
  brake_settings.t2 = 500;
  brake_settings.t3 = 300;
  brake_settings.t4 = 400;
  brake_settings.BrakeFlags = BRAKE_ENG_PWROFF;
  result = set_brake_settings(id, &brake_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  control_settings_t control_settings;
  memset((void*)&control_settings, 0, sizeof(control_settings_t));
  control_settings.MaxSpeed[0] = 48;
  control_settings.MaxSpeed[1] = 482;
  control_settings.MaxSpeed[2] = 4823;
  control_settings.MaxSpeed[3] = 0;
  control_settings.MaxSpeed[4] = 0;
  control_settings.MaxSpeed[5] = 0;
  control_settings.MaxSpeed[6] = 0;
  control_settings.MaxSpeed[7] = 0;
  control_settings.MaxSpeed[8] = 0;
  control_settings.MaxSpeed[9] = 0;
  const uint8_t control_settings_uMaxSpeed_temp[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(control_settings.uMaxSpeed, control_settings_uMaxSpeed_temp, sizeof(uint8_t) * 10);
  control_settings.Timeout[0] = 1000;
  control_settings.Timeout[1] = 1000;
  control_settings.Timeout[2] = 1000;
  control_settings.Timeout[3] = 1000;
  control_settings.Timeout[4] = 1000;
  control_settings.Timeout[5] = 1000;
  control_settings.Timeout[6] = 1000;
  control_settings.Timeout[7] = 1000;
  control_settings.Timeout[8] = 1000;
  control_settings.MaxClickTime = 300;
  control_settings.Flags = CONTROL_MODE_LR | CONTROL_MODE_OFF;
  control_settings.DeltaPosition = 1;
  control_settings.uDeltaPosition = 0;
  result = set_control_settings(id, &control_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  joystick_settings_t joystick_settings;
  memset((void*)&joystick_settings, 0, sizeof(joystick_settings_t));
  joystick_settings.JoyLowEnd = 0;
  joystick_settings.JoyCenter = 5000;
  joystick_settings.JoyHighEnd = 10000;
  joystick_settings.ExpFactor = 100;
  joystick_settings.DeadZone = 50;
  joystick_settings.JoyFlags = 0;
  result = set_joystick_settings(id, &joystick_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  ctp_settings_t ctp_settings;
  memset((void*)&ctp_settings, 0, sizeof(ctp_settings_t));
  ctp_settings.CTPMinError = 3;
  ctp_settings.CTPFlags = 0;
  result = set_ctp_settings(id, &ctp_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  uart_settings_t uart_settings;
  memset((void*)&uart_settings, 0, sizeof(uart_settings_t));
  uart_settings.Speed = 115200;
  uart_settings.UARTSetupFlags = UART_PARITY_BIT_EVEN;
  result = set_uart_settings(id, &uart_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  controller_name_t controller_name;
  memset((void*)&controller_name, 0, sizeof(controller_name_t));
  const int8_t controller_name_ControllerName_temp[16] = {0, 86, -122, 0, 0, 0, -122, 0, 0, 0, 0, 0, 0, 0, -122, 0};
  memcpy(controller_name.ControllerName, controller_name_ControllerName_temp, sizeof(int8_t) * 16);
  controller_name.CtrlFlags = 0;
  result = set_controller_name(id, &controller_name);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  stage_name_t stage_name;
  memset((void*)&stage_name, 0, sizeof(stage_name_t));
  const int8_t stage_name_PositionerName_temp[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(stage_name.PositionerName, stage_name_PositionerName_temp, sizeof(int8_t) * 16);
  result = set_stage_name(id, &stage_name);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  stage_information_t stage_information;
  memset((void*)&stage_information, 0, sizeof(stage_information_t));
  const int8_t stage_information_Manufacturer_temp[16] = {83, 116, 97, 110, 100, 97, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(stage_information.Manufacturer, stage_information_Manufacturer_temp, sizeof(int8_t) * 16);
  const int8_t stage_information_PartNumber_temp[24] = {56, 67, 77, 65, 49, 54, 68, 67, 86, 45, 49, 51, 95, 49, 53, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(stage_information.PartNumber, stage_information_PartNumber_temp, sizeof(int8_t) * 24);
  result = set_stage_information(id, &stage_information);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  stage_settings_t stage_settings;
  memset((void*)&stage_settings, 0, sizeof(stage_settings_t));
  stage_settings.LeadScrewPitch = 0.25;
  const int8_t stage_settings_Units_temp[8] = {109, 109, 0, 114, 101, 101, 0, 0};
  memcpy(stage_settings.Units, stage_settings_Units_temp, sizeof(int8_t) * 8);
  stage_settings.MaxSpeed = 0.15000000596046448;
  stage_settings.TravelRange = 13;
  stage_settings.SupplyVoltageMin = 12;
  stage_settings.SupplyVoltageMax = 36;
  stage_settings.MaxCurrentConsumption = 0;
  stage_settings.HorizontalLoadCapacity = 0;
  stage_settings.VerticalLoadCapacity = 0;
  result = set_stage_settings(id, &stage_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  motor_information_t motor_information;
  memset((void*)&motor_information, 0, sizeof(motor_information_t));
  const int8_t motor_information_Manufacturer_temp[16] = {70, 65, 85, 76, 72, 65, 66, 69, 82, 0, 116, 114, 111, 108, 32, 80};
  memcpy(motor_information.Manufacturer, motor_information_Manufacturer_temp, sizeof(int8_t) * 16);
  const int8_t motor_information_PartNumber_temp[24] = {49, 53, 50, 52, 84, 48, 48, 54, 83, 82, 0, 0, 48, 52, 66, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(motor_information.PartNumber, motor_information_PartNumber_temp, sizeof(int8_t) * 24);
  result = set_motor_information(id, &motor_information);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  motor_settings_t motor_settings;
  memset((void*)&motor_settings, 0, sizeof(motor_settings_t));
  motor_settings.MotorType = MOTOR_TYPE_DC | MOTOR_TYPE_UNKNOWN;
  motor_settings.ReservedField = 0;
  motor_settings.Poles = 0;
  motor_settings.Phases = 0;
  motor_settings.NominalVoltage = 6;
  motor_settings.NominalCurrent = 0.550000011920929;
  motor_settings.NominalSpeed = 4300;
  motor_settings.NominalTorque = 2.799999952316284;
  motor_settings.NominalPower = 1.7000000476837158;
  motor_settings.WindingResistance = 5.099999904632568;
  motor_settings.WindingInductance = 0.07000000029802322;
  motor_settings.RotorInertia = 0.6600000262260437;
  motor_settings.StallTorque = 6.679999828338623;
  motor_settings.DetentTorque = 0;
  motor_settings.TorqueConstant = 5.800000190734863;
  motor_settings.SpeedConstant = 1650;
  motor_settings.SpeedTorqueGradient = 1450;
  motor_settings.MechanicalTimeConstant = 10;
  motor_settings.MaxSpeed = 6000;
  motor_settings.MaxCurrent = 0.8299999833106995;
  motor_settings.MaxCurrentTime = 0;
  motor_settings.NoLoadCurrent = 0.020999999716877937;
  motor_settings.NoLoadSpeed = 9700;
  result = set_motor_settings(id, &motor_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  encoder_information_t encoder_information;
  memset((void*)&encoder_information, 0, sizeof(encoder_information_t));
  const int8_t encoder_information_Manufacturer_temp[16] = {70, 65, 85, 76, 72, 65, 66, 69, 82, 0, 46, 0, 0, 0, 0, 0};
  memcpy(encoder_information.Manufacturer, encoder_information_Manufacturer_temp, sizeof(int8_t) * 16);
  const int8_t encoder_information_PartNumber_temp[24] = {73, 69, 50, 45, 49, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(encoder_information.PartNumber, encoder_information_PartNumber_temp, sizeof(int8_t) * 24);
  result = set_encoder_information(id, &encoder_information);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  encoder_settings_t encoder_settings;
  memset((void*)&encoder_settings, 0, sizeof(encoder_settings_t));
  encoder_settings.MaxOperatingFrequency = 7;
  encoder_settings.SupplyVoltageMin = 4;
  encoder_settings.SupplyVoltageMax = 18;
  encoder_settings.MaxCurrentConsumption = 12;
  encoder_settings.PPR = 16;
  encoder_settings.EncoderSettings = 0;
  result = set_encoder_settings(id, &encoder_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  hallsensor_information_t hallsensor_information;
  memset((void*)&hallsensor_information, 0, sizeof(hallsensor_information_t));
  const int8_t hallsensor_information_Manufacturer_temp[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(hallsensor_information.Manufacturer, hallsensor_information_Manufacturer_temp, sizeof(int8_t) * 16);
  const int8_t hallsensor_information_PartNumber_temp[24] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(hallsensor_information.PartNumber, hallsensor_information_PartNumber_temp, sizeof(int8_t) * 24);
  result = set_hallsensor_information(id, &hallsensor_information);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  hallsensor_settings_t hallsensor_settings;
  memset((void*)&hallsensor_settings, 0, sizeof(hallsensor_settings_t));
  hallsensor_settings.MaxOperatingFrequency = 0;
  hallsensor_settings.SupplyVoltageMin = 0;
  hallsensor_settings.SupplyVoltageMax = 0;
  hallsensor_settings.MaxCurrentConsumption = 0;
  hallsensor_settings.PPR = 0;
  result = set_hallsensor_settings(id, &hallsensor_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  gear_information_t gear_information;
  memset((void*)&gear_information, 0, sizeof(gear_information_t));
  const int8_t gear_information_Manufacturer_temp[16] = {70, 65, 85, 76, 72, 65, 66, 69, 82, 0, 0, 0, 0, 0, 0, 0};
  memcpy(gear_information.Manufacturer, gear_information_Manufacturer_temp, sizeof(int8_t) * 16);
  const int8_t gear_information_PartNumber_temp[24] = {49, 54, 47, 55, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(gear_information.PartNumber, gear_information_PartNumber_temp, sizeof(int8_t) * 24);
  result = set_gear_information(id, &gear_information);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  gear_settings_t gear_settings;
  memset((void*)&gear_settings, 0, sizeof(gear_settings_t));
  gear_settings.ReductionIn = 134;
  gear_settings.ReductionOut = 1;
  gear_settings.RatedInputTorque = 0.30000001192092896;
  gear_settings.RatedInputSpeed = 5000;
  gear_settings.MaxOutputBacklash = 1;
  gear_settings.InputInertia = 0;
  gear_settings.Efficiency = 60;
  result = set_gear_settings(id, &gear_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  accessories_settings_t accessories_settings;
  memset((void*)&accessories_settings, 0, sizeof(accessories_settings_t));
  const int8_t accessories_settings_MagneticBrakeInfo_temp[24] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(accessories_settings.MagneticBrakeInfo, accessories_settings_MagneticBrakeInfo_temp, sizeof(int8_t) * 24);
  accessories_settings.MBRatedVoltage = 0;
  accessories_settings.MBRatedCurrent = 0;
  accessories_settings.MBTorque = 0;
  accessories_settings.MBSettings = 0;
  const int8_t accessories_settings_TemperatureSensorInfo_temp[24] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  memcpy(accessories_settings.TemperatureSensorInfo, accessories_settings_TemperatureSensorInfo_temp, sizeof(int8_t) * 24);
  accessories_settings.TSMin = 0;
  accessories_settings.TSMax = 0;
  accessories_settings.TSGrad = 0;
  accessories_settings.TSSettings = TS_TYPE_THERMOCOUPLE | TS_TYPE_UNKNOWN;
  accessories_settings.LimitSwitchesSettings = 0;
  result = set_accessories_settings(id, &accessories_settings);

  if (result != result_ok)
  {
    if (worst_result == result_ok || worst_result == result_value_error)
    {
      worst_result = result;
    }
  }

  return worst_result;
}

#endif