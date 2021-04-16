{:use--paq
 (fn use--paq [plug] 
   (if (list? plug)
     (do 
         (tset plug 2 1 (. plug 1))
         `(paq.paq ,(. plug 2)))
     `(paq.paq ,plug)))

 ;; Paq
 :use
 (fn [plug ...]
   (if (sequence? plug)
     (let [paqs (icollect [_ p (ipairs plug)]
                          (use--paq p))]
       `(do (do ,(values (unpack paqs))) ,...))
     `(do ,(use--paq plug) ,...)))}
