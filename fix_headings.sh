#!/bin/bash

# Script to update all markdown files with better heading formats
# Replace "Non-Technical Example" with more engaging titles

# Find all markdown files except git directory
find . -name "*.md" -not -path "./.git/*" | while read -r file; do
    echo "Processing $file"
    
    # Replace Non-Technical Example with "Real World Analogy"
    sed -i 's/# Non-Technical Example/# Real World Analogy/' "$file"
    
    # Replace Technical Description with "Technical Explanation"
    sed -i 's/# Technical Description/# Technical Explanation/' "$file"
    
    # Replace Hands-On Lab with "Lab Exercise"
    sed -i 's/# Hands-On Lab/# Lab Exercise/' "$file"
done

echo "All headings updated successfully!"