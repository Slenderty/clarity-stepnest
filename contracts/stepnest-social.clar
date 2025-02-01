;; StepNest Social Contract

;; Constants
(define-constant err-already-liked (err u200))
(define-constant err-not-found (err u201))

;; Data structures
(define-map likes 
  { user: principal, route-id: uint } 
  { timestamp: uint }
)

(define-map bookmarks
  { user: principal, route-id: uint }
  { timestamp: uint }
)

;; Public functions
(define-public (like-route (route-id uint))
  (let ((existing (map-get? likes { user: tx-sender, route-id: route-id })))
    (if (is-some existing)
      err-already-liked
      (begin
        (map-set likes 
          { user: tx-sender, route-id: route-id }
          { timestamp: block-height }
        )
        (ok true)))))

(define-public (bookmark-route (route-id uint))
  (map-set bookmarks
    { user: tx-sender, route-id: route-id }
    { timestamp: block-height }
  )
  (ok true))

;; Read only functions
(define-read-only (get-likes (route-id uint))
  (ok (map-get? likes { user: tx-sender, route-id: route-id })))

(define-read-only (get-bookmarks (route-id uint))
  (ok (map-get? bookmarks { user: tx-sender, route-id: route-id })))
