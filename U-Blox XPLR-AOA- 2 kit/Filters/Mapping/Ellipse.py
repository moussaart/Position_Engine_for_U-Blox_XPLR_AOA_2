
import numpy as np 




class Ellipse :
    
    def __init__(self,a=1, b=1, n=100,tour=1):
        
        self.a=a
        self.b=b
        self.n=n
        self.tour=tour
        
    def Polar_coordinates(self) :
        
        self.theta = np.linspace(0, self.tour*2*np.pi, self.n)  # n points répartis sur 2π radians
        self.r = (self.a * self.b) / np.sqrt((self.b * np.cos(self.theta))**2 + (self.a * np.sin(self.theta))**2)
        return self.r, self.theta
    
    def Cartesian_coordinates(self) :
        
        self.theta = np.linspace(0, self.tour*2*np.pi, self.n)  # n points répartis sur 2π radians
        self.r = (self.a * self.b) / np.sqrt((self.b * np.cos(self.theta))**2 + (self.a * np.sin(self.theta))**2)
        self.x = self.r * np.cos(self.theta)
        self.y = self.r * np.sin(self.theta)
        
        return self.x , self.y
    
    def add_noise_polar(self,sigma_r,sigma_theta):
        
        r=self.r+np.random.normal(0,sigma_r,self.n)
        theta=self.theta+np.random.normal(0,sigma_theta,self.n)
        
        return r , theta
    
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
        
        angles= self.angles+ np.random.normal(0,sigma_angle,size=self.angles.shape)
        
        return angles
    
    def get_r(self) :
        
        return self.r
    
    def get_theta(self) :
        
        return self.theta
    
    def get_x(self) :
        
        return self.x
    
    def get_y(self) :
        
        return self.y    
    
    

def inv_Triangulation(x,y,ref_points ):
        angles = []
        N=len(ref_points)
        for i in range(N):
            x_i, y_i = ref_points[i]
            angle = float(np.arctan2(y - y_i, x - x_i))
                
            angles.append(angle)
                
        return angles
    
def Car2Pol(x,y) :
    theta=np.arctan2(y,x)
    r=np.sqrt(x**2+y**2)
    return r ,theta

def Pol2Car(r,theta) :
    x=r*np.cos(theta)
    y=r*np.sin(theta)
    return x,y

def Triangulation(angles, ref_points):
    # angles: list of angles between point A and each reference point
    # ref_points: list of reference points with known coordinates (x_i, y_i)
    N = len(ref_points)
    A = []
    b = []
    for i in range(N):
        angle = angles[i]
        x_i, y_i = ref_points[i]
        A.append([np.sin(angle), -np.cos(angle)])
        b.append(np.sin(angle)*x_i - np.cos(angle)*y_i)
    
    A=np.array(A)
    B=np.array(b).reshape((N,1))
    try :
       AA=np.linalg.inv(np.dot(A.T,A))
       BB=np.dot(A.T,B)
       X=np.dot(AA,BB)
       x, y = float(X[0]), float(X[1])
       
       return x, y
    except np.linalg.LinAlgError as e: 
        print("Une erreur s'est produite :", e)
        return 0, 0
