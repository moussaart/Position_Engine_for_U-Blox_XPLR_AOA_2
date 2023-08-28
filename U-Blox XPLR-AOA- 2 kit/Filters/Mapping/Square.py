
import numpy as np 




class Square :
    
    def __init__(self,a=1, b=1, n=100):
        
        self.a=a
        self.b=b
        self.n=n
        self.x_coords = [0, a, a, 0, 0]
        self.y_coords = [0, 0, b, b, 0]
    
    def Cartesian_coordinates(self) :
        
        t = np.linspace(0, 1, self.n)
        t_coords = np.linspace(0, 1, len(self.x_coords))
        x = np.interp(t, t_coords, self.x_coords, period=1)
        y = np.interp(t, t_coords, self.y_coords, period=1)
        
        self.x = x-np.ones(x.shape)*self.a/2
        self.y = y-np.ones(x.shape)*self.b/2
        
        return self.x , self.y
    
    def add_noise_cartesian(self,sigma_x,sigma_y):
        
        x=self.x+np.random.normal(0,sigma_x,self.n)
        y=self.y+np.random.normal(0,sigma_y,self.n)
        
        return x , y
    
    def inv_Triangulation(self,ref_points ):
        self.angles = []
        N=len(ref_points)
        for i in range(N):
            x_i, y_i = ref_points[i]
            x_i, y_i = np.ones(self.x.shape)*x_i,np.ones(self.y.shape)*y_i
            angle = np.arctan2(self.y - y_i, self.x - x_i).reshape((self.n,1)).tolist()
                
            self.angles.append(angle)
                
        self.angles=np.array(self.angles)
        self.angles=self.angles.reshape((len(ref_points),self.n))
        return self.angles
    
    def add_noise_angulation(self, sigma_angle) :
        
        angles= self.angles+ np.random.normal(0,sigma_angle,self.angles.shape)
        
        return angles
    
    def get_r(self) :
        
        return self.r
    
    def get_theta(self) :
        
        return self.theta
    
    def get_x(self) :
        
        return self.x
    
    def get_y(self) :
        
        return self.y    
    
    
    
