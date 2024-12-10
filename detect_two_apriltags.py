from PIL import Image
import cv2
import numpy as np
import robotpy_apriltag as rpa

directory = "C:/Users/Scott Viola/Documents/2024 Fall/ECE 5330 - Robotics/Robot/"
filename = "frame.jpg"

# quaternion to matrix
def quaternion_to_matrix(q):
    matrix = np.zeros((3,3))
    w = q.W()
    x = q.X()
    y = q.Y()
    z = q.Z()
    matrix[0][0] = 1 - 2*y*y - 2*z*z
    matrix[0][1] = 2*x*y  - 2*z*w
    matrix[0][2] = 2*x*z + 2*y*w
    matrix[1][0] = 2*x*y + 2*z*w
    matrix[1][1] = 1  - 2*x*x -2*z*z
    matrix[1][2] = 2*y*z - 2*x*w
    matrix[2][0] = 2*x*z - 2*y*w
    matrix[2][1] = 2*y*z + 2*x*w
    matrix[2][2] = 1 - 2*x*x - 2*y*y
    return matrix
    

# Original image
im = cv2.imread(directory + filename, cv2.IMREAD_GRAYSCALE)
if im is None:
    print("Error: Image not found or could not be loaded.")
    exit()
#print(filename) 

# Grayscale
#print(im.shape)

# Detect Apriltags:
detector = rpa.AprilTagDetector()
detector.addFamily("tag16h5")

tags_detected = detector.detect(im)

def get_margin(detection):
    return detection.getDecisionMargin()

# Display most significant detections:
tags = tags_detected
tags.sort(reverse=True,key=get_margin)

##for tag in tags_detected:
##    if (tag.getDecisionMargin() > 70):
##        tags.append(tag)
##        # print(tag.getId(), tag.getCenter(), tag.getDecisionMargin())
print(" ")


# Position estimator
tagSize = 37
fx = 705.5
fy = 693.0
cx = 665.0
cy = 350.0


estimator = rpa.AprilTagPoseEstimator( rpa.AprilTagPoseEstimator.Config(tagSize, fx,fy,cx,cy) )
estimates = []
for tag in tags:
    est = estimator.estimate(tag)
    pos = est.translation()
    rot = est.rotation()
    #print(rot)
    #print(rot.getQuaternion())
    matrix = quaternion_to_matrix(rot.getQuaternion())
    estimates.append( (tag.getId(),estimator.estimate(tag),tag.getDecisionMargin()) )
    #print(tag.getId(),pos,"\n",matrix)

# Text file outpile
output = open("apriltag_detections_output.txt", mode='w')
text = f"{len(estimates)},{0},{0}\n"
index = 0
while (index < 2) and (index < len(estimates)):
    pose = estimates[index]
    transform = pose[1]
    rotation  = transform.rotation().getQuaternion()
    mat       = quaternion_to_matrix(rotation)
    margin = pose[2]
    ID    = f"{pose[0]},{margin},{0}\n"
    TRANS = f"{transform.X()},{transform.Y()},{transform.Z()}\n"
    ROT   = f"{mat[0][0]},{mat[0][1]},{mat[0][2]}\n{mat[1][0]},{mat[1][1]},{mat[1][2]}\n{mat[2][0]},{mat[2][1]},{mat[2][2]}\n"
    text += ID + TRANS + ROT
    
    index += 1
output.write(text)
output.close()

