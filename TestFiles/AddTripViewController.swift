//
//  AddTripViewController.swift
//

import UIKit


/*
    Protocol for handling submission and cancelation events of the form.
*/
protocol AddTripViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: AddTripViewController)
    func viewController(_ controller: AddTripViewController, didAdd newTrip: Trip)
}


class AddTripViewController: UITableViewController {
    @IBOutlet private var destinationTextField: UITextField!
    @IBOutlet private var imagePickerButton: UIButton!
    @IBOutlet private var doneButton: UIBarButtonItem!


    weak var delegate: AddTripViewControllerDelegate?
    var modelController: TripsModelController!

    var viewModel: ViewModel! {
        didSet {
            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }
                self.render(with: self.viewModel)
            }
        }
    }
}


// MARK: - Computeds
extension AddTripViewController {
    var canUsePhotoLibrary: Bool { UIImagePickerController.isSourceTypeAvailable(.photoLibrary) }

    var tripFromFormData: Trip {
        guard let destination = destinationTextField.text else {
            preconditionFailure("No text value found in destination field")
        }

        let imageData: Data?
        if imagePickerButton.imageView?.image?.isSymbolImage ?? false {
            imageData = imagePickerButton.imageView?.image?.jpegData(compressionQuality: 0.8)
        } else {
            imageData = nil
        }

        return Trip(
            title: destination,
            shortDescription: "",
            primaryImageData: imageData
        )
    }


    var tripPhotoImagePicker: UIImagePickerController {
        let picker = UIImagePickerController()

        picker.allowsEditing = true
        picker.delegate = self

        return picker
    }
}


// MARK: - Lifecycle
extension AddTripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        render(with: viewModel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.destinationTextField.becomeFirstResponder()
        }
    }
}



// MARK: - Event Handling
extension AddTripViewController {

    @IBAction func cancelButtonTapped() {
        delegate?.viewControllerDidCancel(self)
    }


    @IBAction func doneButtonTapped() {
        submitTripData()
    }


    @IBAction func destinationTextFieldEndedOnExit() {
        submitTripData()
    }


    @IBAction func destinationTextFieldChanged() {
        doneButton.isEnabled = destinationTextField.hasText
    }


    @IBAction func imagePickerButtonTapped() {
        let imagePicker = tripPhotoImagePicker

        if canUsePhotoLibrary {
            tripPhotoImagePicker.sourceType = .photoLibrary
        }

        present(imagePicker, animated: true)
    }
}


// MARK: - Private Helpers
private extension AddTripViewController {

    func submitTripData() {
        let newTrip = tripFromFormData

        modelController.create(newTrip) { [weak self] _ in
            self?.delegate?.viewController(self!, didAdd: newTrip)
        }
    }

    func render(with viewModel: ViewModel) {
        mainTitleLabel.text = viewModel.mainTitleText

        destinationTextField.text = viewModel.tripToEdit?.title ?? ""
        destinationTextFieldChanged()
    }
}


// MARK: - UIImagePickerControllerDelegate
extension AddTripViewController: UIImagePickerControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        let imageToSave: UIImage

        if let editedImage = info[.editedImage] as? UIImage {
            imageToSave = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageToSave = originalImage
        } else {
            return
        }

        DispatchQueue.main.async {
            self.imagePickerButton.setImage(imageToSave, for: .normal)
        }

        dismiss(animated: true)
    }
}


extension AddTripViewController: UINavigationControllerDelegate {}
