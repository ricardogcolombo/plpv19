function Monomio(coef, grado) {
    this.coeficiente = coef;
    this.grado = grado;
}

Monomio.prototype.evaluar = function(n) {
    return this.coeficiente * (n ** (this.grado))
}

Monomio.prototype.gradoMayor = function() {
    return this.grado;
}

Monomio.prototype.coefDeGrado = function(g) {
    return this.grado === g ? this.coeficiente : 0;
}

function Sumatoria(p1, p2) {
    this.izq = p1;
    this.der = p2;
}

Sumatoria.prototype.evaluar = function(n) {
    return this.izq.evaluar(n) + this.der.evaluar(n);
}

Sumatoria.prototype.gradoMayor = function() {
    return Math.max(this.izq.gradoMayor(), this.der.gradoMayor());
}

Sumatoria.prototype.coefDeGrado = function(g) {
    return this.izq.coefDeGrado(g) + this.der.coefDeGrado(g);
}

Sumatoria.prototype.grado = function() {
    let gradoMayor = this.gradoMayor();
    let max = this.coefDeGrado(0)
    for (var i = 1; i <= gradoMayor; i++) {
        if (max < this.coefDeGrado(i)) {
            max = i
        }
    }
    return max
}

Sumatoria.prototype.toString = function() {
    let gradoMayor = this.gradoMayor();
    let str = ""
    for (var i = gradoMayor; i >= 0; i--) {
        //si el coeficiente es distinto de 0 
        if (this.coefDeGrado(i) !== 0)
            // caso string vacion no agrego el signo
            if (str.length > 0)
                str += "+"

        // agrego el coeficiente
        str += this.coefDeGrado(i)

        // si el grado es 0 no agrego el string X	
        if (i > 0)
            str += "X"
        if (i > 1)
            str += "^" + i
    }
    return str
}

Sumatoria.prototype.aPolinomio = function() {
    var g = this.gradoMayor();
    let m1
    let m2
    let res
    for (var i = 0; i <= g; i++) {
        if (this.coefDeGrado(i) !== 0)
            if (!m1) {
                m1 = new Monomio(this.coefDeGrado(i), i);
            } else if (!m2) {
            m2 = new Monomio(this.coefDeGrado(i), i);
            res = new Sumatoria(m2, m1)
        } else {
            m = new Monomio(this.coefDeGrado(i), i);
            res = new Sumatoria(m, res)
        }

    }
    return res
}




let s = new Monomio(7, 2);
let s2 = new Monomio(8, 1);
let s3 = new Monomio(-3, 1);
let s4 = new Monomio(4, 0);
let ss1 = new Sumatoria(s, s2)
let ss2 = new Sumatoria(s3, s4)
let ssF = new Sumatoria(ss1, ss2)