import json


class Report:
    def __init__(self, name):
        self.report = {"name": name,
                       "actions": []
                       }

    def add_action(self, name, usedGas, gasPrice, tx):
        if self._is_report_does_not_contain_action(name):
            self.report["actions"].append({"name": name, "usedGas": usedGas, "gasPrice": gasPrice, "tx": tx})

    def save(self):
        with open("report.json", "w") as f:
            json.dump(self.report, f)

    def _is_report_does_not_contain_action(self, action):
        for item in self.report["actions"]:
            if action in item["name"]:
                return False
        return True