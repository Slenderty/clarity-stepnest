;; StepNest Core Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-route (err u101))
(define-constant err-already-exists (err u102))

;; Data structures
(define-map routes 
  { route-id: uint }
  {
    creator: principal,
    name: (string-utf8 100),
    description: (string-utf8 500),
    difficulty: uint,
    distance: uint,
    coordinates: (list 100 (tuple (lat int) (lng int))),
    created-at: uint
  }
)

(define-map activities
  { activity-id: uint }
  {
    user: principal,
    route-id: uint,
    duration: uint,
    completed: bool,
    started-at: uint
  }
)

;; Variables
(define-data-var next-route-id uint u1)
(define-data-var next-activity-id uint u1)

;; Public functions
(define-public (create-route (name (string-utf8 100)) 
                           (description (string-utf8 500))
                           (difficulty uint)
                           (distance uint)
                           (coordinates (list 100 (tuple (lat int) (lng int)))))
  (let ((route-id (var-get next-route-id)))
    (map-set routes
      { route-id: route-id }
      {
        creator: tx-sender,
        name: name,
        description: description,
        difficulty: difficulty,
        distance: distance,
        coordinates: coordinates,
        created-at: block-height
      }
    )
    (var-set next-route-id (+ route-id u1))
    (ok route-id)))

(define-public (start-activity (route-id uint))
  (let ((activity-id (var-get next-activity-id)))
    (map-set activities
      { activity-id: activity-id }
      {
        user: tx-sender,
        route-id: route-id,
        duration: u0,
        completed: false,
        started-at: block-height
      }
    )
    (var-set next-activity-id (+ activity-id u1))
    (ok activity-id)))

;; Read only functions
(define-read-only (get-route (route-id uint))
  (ok (map-get? routes { route-id: route-id })))

(define-read-only (get-activity (activity-id uint))
  (ok (map-get? activities { activity-id: activity-id })))
