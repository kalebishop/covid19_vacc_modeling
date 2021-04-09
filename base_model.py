THRESHOLD = 0.7

class SimpleAgent:
    def __init__(self, i_cost_pro, i_cost_con):
        self.i_cost_pro = i_cost_pro
        self.i_cost_con = i_cost_con
        self.i_belief_neighbors = None
        self.threshold = THRESHOLD

        self.vaccinated = False
        self.incurred_cost = i_cost_con

    def is_vaccinated(self):
        return self.vaccinated
    
    def get_vaccine(self):
        self.vaccinated = True
        self.incurred_cost = self.cost_pro

    def update(self, neighbors):
        total_vaxed = 0
        for n in neighbors:
            if n.is_vaccinated():
                total_vaxed += 1
        return total_vaxed / len(neighbors)

class CommunityModel:
    def __init__(self, n, neighbor_radius):
        self.num_agents = n
        self.agents = self.populate_agents()
        self.radius = neighbor_radius

    def update(self):
        for i in self.agents:
            neighbors = self.agents[max(i - self.radius, 0): min(i + self.radius, self.num_agents)]
            i.update(neighbors)