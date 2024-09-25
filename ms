import cv2
import pytesseract
from pdf2image import convert_from_path
import re
import pandas as pd

# Step 1: Convert PDF to Image
pdf_path = 'input.pdf'
images = convert_from_path(pdf_path)

# Step 2: Process each image
pytesseract.pytesseract.tesseract_cmd = r'/usr/bin/tesseract'  # Set your tesseract path here
text_data = ""

for image in images:
    # Convert image to grayscale
    gray = cv2.cvtColor(np.array(image), cv2.COLOR_BGR2GRAY)
    
    # Apply image processing techniques (e.g., thresholding)
    _, thresh = cv2.threshold(gray, 128, 255, cv2.THRESH_BINARY)
    
    # Extract text using OCR
    text = pytesseract.image_to_string(thresh)
    text_data += text

# Step 3: Apply regular expressions to extract patient and medicine information
patient_pattern = r"Patient Name: (.+)"
medicine_pattern = r"Medicine: (.+)"

patient_matches = re.findall(patient_pattern, text_data)
medicine_matches = re.findall(medicine_pattern, text_data)

# Step 4: Create a DataFrame and save to Excel
data = {'Patient Name': patient_matches, 'Medicine': medicine_matches}
df = pd.DataFrame(data)
df.to_excel('output.xlsx', index=False)

print("Data extracted and saved to output.xlsx")
