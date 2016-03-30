//
//  CategoryViewController.swift
//  SteppingStone
//
//  Created by Jeff Chimney on 2016-02-28.
//  Copyright © 2016 Jeff Chimney. All rights reserved.
//

import UIKit
import AVFoundation

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var unselectedCollectionView: UICollectionView!
    @IBOutlet var selectedCollectionView: UICollectionView!
    @IBOutlet var playButton: UIButton!
    
    let reuseIdentifier = "cell"
    let selectedReuseIdentifier = "selectedCell"
    var currentCategory = ""
    var imageArray = [String]()
    var selectedCells = [MyCollectionViewCell]()
    var selectedCellIndex = 0
    let maximumSelectedWords = 3
    
    // will hold selected images
    var tappedImages = [String]()
    var numberOfImagesSelected = 0
    
    // initialize audioplayer
    var audioPlayer = AVAudioPlayer()
    
    override func viewWillLayoutSubviews() {
        // find absolute paths of images
        let fm = NSFileManager.defaultManager()
        currentCategory = "Categories/" + categoryName
        let path = NSBundle.mainBundle().resourcePath! + "/" + currentCategory
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            imageArray.append(item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.enabled = false
    }

    var categoryName = String()
    
    override func viewWillAppear(animated: Bool) {
        categoryLabel.text = categoryName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /////////////////////////UICollectionViewDataSource protocol\\\\\\\\\\\\\\\\\\\\\\
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.unselectedCollectionView {
            return self.imageArray.count
        } else {
            return maximumSelectedWords
        }
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == self.unselectedCollectionView {
        
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
            let currentImage = currentCategory + "/" + imageArray[indexPath.item]
            print(currentImage)
        
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.backgroundColor = UIColor.whiteColor() // make cell more visible in our example project
            cell.imageCell.image = UIImage(named: currentImage)
            
            return cell
        
        } else {
            
            selectedCells.append(collectionView.dequeueReusableCellWithReuseIdentifier(selectedReuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell)
            
            selectedCells[selectedCellIndex].backgroundColor = UIColor.whiteColor()
            
            selectedCellIndex = selectedCellIndex + 1
            
            return selectedCells[selectedCellIndex-1]
        }
    }
    
    /////////////////////////UICollectionViewDelegate protocol\\\\\\\\\\\\\\\\\\\\\\
    
    
    // called when user taps a cell in collectionview
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView == unselectedCollectionView {
            // handle tap events
            
            if numberOfImagesSelected < maximumSelectedWords {
                tappedImages.append(imageArray[indexPath.item])
                tappedImages[numberOfImagesSelected] = String(tappedImages[numberOfImagesSelected].characters.dropLast(4))
        
                playSoundWithName(tappedImages[numberOfImagesSelected])
        
                print("You selected the \(tappedImages[numberOfImagesSelected])!")
        
                selectedCells[numberOfImagesSelected].selectedViewCell.image = UIImage(named: currentCategory + "/" + tappedImages[numberOfImagesSelected] + ".png")
            
            
                numberOfImagesSelected = numberOfImagesSelected + 1
                print(numberOfImagesSelected)
                print(tappedImages)
                
                playButton.enabled = true
            }
        } else {
            // handle 'selected' tap
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //////////////////////// Audio \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    func playSoundWithName(fileName: String) {

        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/" + fileName, ofType: "m4a")!)
        
        var error:NSError?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: alertSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch _ {
            
        }
    }
    
    @IBAction func playQueuedWords(sender: AnyObject) {
        for image in tappedImages {
            self.playSoundWithName(image)
            sleep(1)
        }
        
        for each in selectedCells {
            each.selectedViewCell.image = UIImage(named: "")
        }
        numberOfImagesSelected = 0
        selectedCellIndex = 0
        tappedImages = []
        playButton.enabled = false
    }
}
