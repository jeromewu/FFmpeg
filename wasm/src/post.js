/**
  * Export the function for exiting the runtime
  */
Module['exit'] = function(status){
  noExitRuntime=false; // noExitRuntime should be false to exit the runtime
  _exit(status);
}