//The variable autist is named autist becasue it holds the player entity.

function megaHealth()
{
  //printl("You picked up full health");

  local health = activator.GetMaxHealth();

  //printl(health);

  activator.SetHealth(health * 1.5);
}

function bunnyHop()
{
  //printl("Bunny");

  local autist  = null;
  autist        = Entities.FindByClassname(autist, "player");

  local velocity = autist.GetAbsVelocity();
  local jumping = autist.IsJumping();
  local playerClass = autist.GetPlayerClass();
  //The InCond method pulls a boolean from the ETFCond enum and TF_COND_BLASTJUMPING is value 81.
  local blastJump = autist.InCond(81);

  if(jumping == true && blastJump == false)
  {
    //printl(playerClass);

    switch(playerClass)
    {
      case 6:
        //playerClass(6) is Heavy and this buffs his speed.
        autist.SetAbsVelocity(Vector(velocity.x * 1.3, velocity.y * 1.3, velocity.z));

        //velocity = autist.GetAbsVelocity();
        //printl(velocity + " heavy");

        break;
      default:
        autist.SetAbsVelocity(Vector(velocity.x * 1.2, velocity.y * 1.2, velocity.z));

        //velocity = autist.GetAbsVelocity();
        //printl(velocity);

        break;
    }
  }
}

function dashieSpin()
{
  local dashie  = null;
  dashie        = Entities.FindByName(dashie, "Dashie");

  local angle = dashie.GetAbsAngles();

  dashie.SetAbsAngles(QAngle(angle.x, angle.y + 1.5, angle.z));

  //printl(angle);
}

zToggle <- null;

//zToggle has to be global here to store the bool value.
function dashieFloat()
{
  local dashie  = null;
  dashie        = Entities.FindByName(dashie, "Dashie");

  local pos = dashie.GetOrigin();
  //printl(pos);

  //pos.z CHANGES ON A PER MAP/PROP LOCATION BASIS!
  //THE VALUE ON THE RIGHT OF THE == WILL HAVE TO CHANGE WITH EACH PROP!
  //Perhaps this can be fixed with an initial pos.z global variable, but I want to save memory over convience.
  if(pos.z == -1006.0)
  {
    zToggle = true;
  }
  if(pos.z == -986.0)
  {
    zToggle = false;
  }

  //printl(zToggle);

  if(zToggle == true)
  {
    //originAdd();
    dashie.SetAbsOrigin(Vector(pos.x, pos.y, pos.z + 0.25));

    //pos = dashie.GetOrigin();
    //printl(pos);
  }
  if(zToggle == false)
  {
    //originSubtract();
    dashie.SetAbsOrigin(Vector(pos.x, pos.y, pos.z - 0.25));

    //pos = dashie.GetOrigin();
    //printl(pos);
  }
}

//dashieReset uses the info of where I position Dashie in game.
//Just like pos.z it will vary map to map/prop to prop.
function dashieReset()
{
  local dashie  = null;
  dashie        = Entities.FindByName(dashie, "Dashie");

  //I'm serious, change these values to be default Dashie position.
  dashie.SetAbsOrigin(Vector(5057.0, -392, -1006.0));

  EntFire("dashieSpawnTimer", "ResetTimer");
  EntFire("quadTime", "Disable");
  EntFire("critPlayerCheck", "Disable");
  EntFire("Dashie", "Disable");
  EntFire("dashieTrigger", "Disable");
  EntFire("dashieSpinTimer", "Disable");
  EntFire("trackingTrigger", "Disable");

  printl("Quad expired");


  local critEnjoyer  = null;
  critEnjoyer        = Entities.FindByClassname(critEnjoyer, "player");

  if(critEnjoyer.InCond(34) == true)
  {
    critEnjoyer.RemoveCond(34);
  }
}

function quadDamage()
{
  //printl("Dashie disabled");

  //AddCondEx(34, 8.0, null) sets TF_COND_CRITBOOSTED_USER_BUFF on the ETFCond enum to true for 8 seconds
  activator.AddCondEx(34, 10.0, null);

  playerTrack();
}

function critPlayerCheck()
{
  local critEnjoyer  = null;
  critEnjoyer        = Entities.FindByClassname(critEnjoyer, "player");


  if(critEnjoyer.InCond(34) == false)
  {
    //printl("Quad dropped");

    local dashie  = null;
    dashie        = Entities.FindByName(dashie, "Dashie");

    dashie.SetAbsOrigin(Vector(critLoc.x, critLoc.y, critLoc.z + 20.0));

    local dashiePos = dashie.GetOrigin();

    EntFire("critPlayerCheck", "Disable");
    EntFire("Dashie", "Enable");
    EntFire("dashieTrigger", "Enable");
    EntFire("dashieSpinTimer", "Enable");

    //This says dashie is dropped while player still has crits.
    //ClientPrint(null, 4, "Dashie has been dropped!");
  }
  else
  {
    //printl("Player has the quad");
    return;
  }
}

critLoc <- null;

function playerTrack()
{
  local trackTrig = null;
  trackTrig = Entities.FindByName(trackTrig, "trackingTrigger");
  critLoc = activator.GetOrigin();

  trackTrig.SetAbsOrigin(Vector(critLoc.x, critLoc.y, critLoc.z + 40.0));

  //printl("Currently tracking");
}

//dashieTrigger has 7 inputs and to reduce Hammer I/O hell they will just be EntFired.
//Make sure all of the names are properly assigned to the props in Hammer.
function dashieInputs()
{
  EntFire("Dashie", "Disable");
  EntFire("dashieSpinTimer", "Disable");
  EntFire("dashieFloatTimer", "Disable");

  EntFire("quadTime", "Enable");
  EntFire("critPlayerCheck", "Enable");
  EntFire("trackingTrigger", "Enable");

  EntFire("dashieTrigger", "Disable");
}

function dashieTaken()
{
  //ClientPrint(null, 3, "\x03 Dashie has been taken!");
  ClientPrint(null, 4, "Dashie has been taken!");
}