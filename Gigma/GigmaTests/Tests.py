import os
import sys

PASS = True
FAIL = False

class Tests:

    exitCode = 0

    def _runAll(self):
        publicMethods = [method for method in dir(self) if callable(getattr(self, method)) if not method.startswith('_')]
        for method in publicMethods:
            if getattr(self, method)() == FAIL:
                print(f"Failed test {method}")
                self.exitCode += 1 
            else:
                print(f"Test passed")

    def checkAppDelegateHeaderExists(self): 
        PATH = "Gigma/Gigma/AppDelegate.h"
        return os.path.exists(PATH)
        

run = Tests()
run._runAll()
sys.exit(run.exitCode)